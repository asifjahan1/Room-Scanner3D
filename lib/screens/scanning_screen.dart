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
  late AnimationController _processingAnimationController;
  final ScanningController controller = Get.find<ScanningController>();

  @override
  void initState() {
    super.initState();
    _processingAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _processingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Live Camera Stream via Native AR Platform View
          Positioned.fill(
            child: _buildScannerView(),
          ),

          // Main Video-Style Scan Overlay UI (timer, shutter, mini-map, guidance)
          Obx(() => ScanOverlay(
                isScanning: controller.isScanning.value,
                isRecording: controller.isRecording.value,
                recordingDurationText: controller.recordingDurationText,
                scanProgress: controller.scanProgress.value,
                wallsDetected: controller.wallsDetected.value,
                guidanceMessage: controller.guidanceMessage.value,
                trackingQuality: controller.trackingQuality.value,
                warnings: controller.warnings.toList(),
                onShutterTap: () async {
                  if (!controller.isRecording.value) {
                    await controller.startScanning();
                  } else {
                    // During continuous video recording, tapping the main red stop shutter triggers stop & process
                    await controller.stopScanning();
                  }
                },
                onDoneTap: () async {
                  await controller.stopScanning();
                },
                onSettingsTap: () => Get.toNamed(AppRoutes.settings),
                onFlashTap: () {},
              )),

          // Initializing AR sensor overlay
          Obx(() {
            if (controller.isInitialized.value) return const SizedBox.shrink();
            return Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.85),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.accentTeal,
                        strokeWidth: 3.5,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Initializing 3D Room Scanner...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Post-Scan Processing & 3D Reconstruction Overlay
          Obx(() {
            if (!controller.isProcessing.value) return const SizedBox.shrink();
            return Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.9),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 36),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14141E),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      border: Border.all(
                        color: AppTheme.accentTeal.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentTeal.withValues(alpha: 0.2),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _processingAnimationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _processingAnimationController.value * 2 * 3.1415926535,
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.accentTeal,
                                    width: 3,
                                    style: BorderStyle.solid,
                                  ),
                                  gradient: SweepGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppTheme.accentTeal.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.architecture_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Processing Scan Data...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Reconstructing 3D topology & aligning detected room boundaries to orthogonal layout...',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            backgroundColor: Color(0xFF232333),
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentTeal),
                            minHeight: 5,
                          ),
                        ),
                      ],
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
      debugPrint('Platform view creation error: $e');
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
