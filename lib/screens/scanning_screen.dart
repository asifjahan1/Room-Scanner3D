import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../widgets/scan_overlay.dart';
import '../controllers/scanning_controller.dart';
import '../core/routes/app_routes.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLineController;
  final ScanningController controller = Get.find<ScanningController>();

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Live Camera Feed via Platform View
          Positioned.fill(
            child: _buildScannerView(),
          ),

          // Scan line animation
          Obx(() {
            if (!controller.isScanning.value) return const SizedBox.shrink();
            return AnimatedBuilder(
              animation: _scanLineController,
              builder: (context, child) {
                final screenHeight = MediaQuery.of(context).size.height;
                return Positioned(
                  top: _scanLineController.value * screenHeight,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.wireframeGlow.withValues(alpha: 0.6),
                          AppTheme.wireframeBlue.withValues(alpha: 0.8),
                          AppTheme.wireframeGlow.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.wireframeGlow.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),

          // Scan overlay UI (buttons, status, tracking quality, warnings)
          Obx(() => ScanOverlay(
                isScanning: controller.isScanning.value,
                scanProgress: controller.scanProgress.value,
                wallsDetected: controller.wallsDetected.value,
                guidanceMessage: controller.guidanceMessage.value,
                trackingQuality: controller.trackingQuality.value,
                warnings: controller.warnings.toList(),
                onShutterTap: () {
                  if (controller.isScanning.value) {
                    controller.captureWall();
                  } else {
                    controller.startScanning();
                  }
                },
                onDoneTap: () async {
                  if (controller.isScanning.value) {
                    final room = await controller.stopScanning();
                    Get.offNamed(AppRoutes.scanComplete, arguments: room);
                  } else {
                    Get.offNamed(AppRoutes.scanComplete, arguments: controller.scannedRoom.value);
                  }
                },
                onSettingsTap: () => Get.toNamed(AppRoutes.settings),
                onFlashTap: () {},
              )),

          // Initializing overlay
          Obx(() {
            if (controller.isInitialized.value) return const SizedBox.shrink();
            return Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.8),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.primaryBlue,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Initializing Scanner...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Tap to start scanning
          Obx(() {
            if (!controller.isInitialized.value || controller.isScanning.value) {
              return const SizedBox.shrink();
            }
            return Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 120,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: controller.startScanning,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentTeal.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      border: Border.all(
                        color: AppTheme.accentTeal.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Text(
                      'Tap to Start Scanning',
                      style: TextStyle(
                        color: AppTheme.accentTeal,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildScannerView() {
    if (Platform.isIOS) {
      return _buildPlatformView('ios-roomplan-view');
    } else if (Platform.isAndroid) {
      return _buildPlatformView('android-arcore-view');
    }
    return _buildDemoView();
  }

  Widget _buildPlatformView(String viewType) {
    try {
      if (Platform.isIOS) {
        return UiKitView(
          viewType: viewType,
          onPlatformViewCreated: (id) {
            controller.setupPlatformChannel(id);
          },
          creationParams: const <String, dynamic>{
            'showWireframe': true,
          },
          creationParamsCodec: const StandardMessageCodec(),
        );
      } else if (Platform.isAndroid) {
        return AndroidView(
          viewType: viewType,
          onPlatformViewCreated: (id) {
            controller.setupPlatformChannel(id);
          },
          creationParams: const <String, dynamic>{
            'showWireframe': true,
            'useDepthAPI': true,
          },
          creationParamsCodec: const StandardMessageCodec(),
        );
      }
    } catch (e) {
      debugPrint('Platform view error: $e');
    }
    return _buildDemoView();
  }

  Widget _buildDemoView() {
    return Container(
      color: const Color(0xFF0A0A12),
      child: CustomPaint(
        painter: _BackgroundGridPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BackgroundGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
