import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/scan_overlay.dart';
import '../services/scanner_service.dart';
import '../models/room_scan.dart';
import 'scan_complete_screen.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with TickerProviderStateMixin {
  bool _isScanning = false;
  bool _isInitialized = false;
  double _scanProgress = 0.0;
  int _wallsDetected = 0;
  MethodChannel? _viewChannel;
  RoomScan? _scannedRoom;

  late AnimationController _wireframeController;
  late Animation<double> _wireframeAnimation;
  late AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();

    _wireframeController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _wireframeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _wireframeController, curve: Curves.linear),
    );

    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _setupPlatformChannel(int id) {
    final channelName = Platform.isIOS
        ? 'com.app.liddar/roomplan_view_$id'
        : 'com.app.liddar/arcore_view_$id';

    _viewChannel = MethodChannel(channelName);
    _viewChannel?.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onScanProgress':
          final data = Map<String, dynamic>.from(call.arguments as Map);
          if (mounted) {
            setState(() {
              _wallsDetected = (data['wallsDetected'] as num?)?.toInt() ?? _wallsDetected;
              _scanProgress = (data['percentage'] as num?)?.toDouble() ?? _scanProgress;
            });
          }
          break;
        case 'onScanComplete':
          final data = Map<String, dynamic>.from(call.arguments as Map);
          _scannedRoom = ScannerService.parseScanResult(data);
          _navigateToComplete();
          break;
        case 'onScanError':
          debugPrint('Scan error: ${call.arguments}');
          break;
      }
    });
  }

  Future<void> _startScanning() async {
    setState(() {
      _isScanning = true;
    });

    try {
      if (_viewChannel != null) {
        await _viewChannel?.invokeMethod('startScan');
      } else {
        await ScannerService.startScan();
      }
    } catch (e) {
      debugPrint('Error starting native scan: $e');
    }
  }

  Future<void> _stopScanning() async {
    setState(() {
      _isScanning = false;
    });

    try {
      if (_viewChannel != null) {
        final result = await _viewChannel?.invokeMethod<Map<dynamic, dynamic>>('stopScan');
        if (result != null) {
          _scannedRoom = ScannerService.parseScanResult(Map<String, dynamic>.from(result));
        }
      } else {
        final result = await ScannerService.stopScan();
        if (result != null) {
          _scannedRoom = ScannerService.parseScanResult(result);
        }
      }
    } catch (e) {
      debugPrint('Error stopping native scan: $e');
    }

    _navigateToComplete();
  }

  void _navigateToComplete() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ScanCompleteScreen(roomScan: _scannedRoom),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _wireframeController.dispose();
    _scanLineController.dispose();
    _isScanning = false;
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

          // Wireframe overlay
          if (_isInitialized)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _wireframeAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _LiveWireframePainter(
                      progress: _wireframeAnimation.value,
                      isScanning: _isScanning,
                      wallsDetected: _wallsDetected,
                    ),
                  );
                },
              ),
            ),

          // Scan line animation
          if (_isScanning)
            AnimatedBuilder(
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
            ),

          // Scan overlay UI (buttons, status)
          ScanOverlay(
            isScanning: _isScanning,
            scanProgress: _scanProgress,
            wallsDetected: _wallsDetected,
            onDoneTap: () {
              if (_isScanning) {
                _stopScanning();
              } else {
                _navigateToComplete();
              }
            },
            onSettingsTap: () {},
            onFlashTap: () {},
          ),

          // Initializing overlay
          if (!_isInitialized)
            Positioned.fill(
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
            ),

          // Tap to start scanning
          if (_isInitialized && !_isScanning)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 120,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _startScanning,
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
            ),
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
            _setupPlatformChannel(id);
          },
          creationParams: <String, dynamic>{
            'showWireframe': true,
          },
          creationParamsCodec: const StandardMessageCodec(),
        );
      } else if (Platform.isAndroid) {
        return AndroidView(
          viewType: viewType,
          onPlatformViewCreated: (id) {
            _setupPlatformChannel(id);
          },
          creationParams: <String, dynamic>{
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

/// Live wireframe painter that animates during scanning
class _LiveWireframePainter extends CustomPainter {
  final double progress;
  final bool isScanning;
  final int wallsDetected;

  _LiveWireframePainter({
    required this.progress,
    required this.isScanning,
    required this.wallsDetected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isScanning && wallsDetected == 0) return;

    final paint = Paint()
      ..color = AppTheme.wireframeWhite.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final glowPaint = Paint()
      ..color = AppTheme.wireframeGlow.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final cx = size.width / 2;
    final cy = size.height / 2;
    final phase = progress * 2 * pi;

    if (wallsDetected >= 1) {
      _drawWall(canvas, paint, glowPaint,
          Offset(cx - 120, cy + 80), Offset(cx + 120, cy + 80), phase);
    }
    if (wallsDetected >= 2) {
      _drawWall(canvas, paint, glowPaint,
          Offset(cx + 120, cy + 80), Offset(cx + 100, cy - 40), phase);
      _drawVertical(canvas, paint, glowPaint,
          Offset(cx + 120, cy + 80), Offset(cx + 100, cy - 120), phase);
    }
    if (wallsDetected >= 3) {
      _drawWall(canvas, paint, glowPaint,
          Offset(cx - 120, cy + 80), Offset(cx - 100, cy - 40), phase);
      _drawVertical(canvas, paint, glowPaint,
          Offset(cx - 120, cy + 80), Offset(cx - 100, cy - 120), phase);
    }
    if (wallsDetected >= 4) {
      _drawWall(canvas, paint, glowPaint,
          Offset(cx - 100, cy - 40), Offset(cx + 100, cy - 40), phase);
      _drawWall(canvas, paint, glowPaint,
          Offset(cx - 100, cy - 120), Offset(cx + 100, cy - 120), phase);
      _drawVertical(canvas, paint, glowPaint,
          Offset(cx + 100, cy - 40), Offset(cx + 100, cy - 120), phase);
      _drawVertical(canvas, paint, glowPaint,
          Offset(cx - 100, cy - 40), Offset(cx - 100, cy - 120), phase);
    }

    final cornerPaint = Paint()
      ..color = AppTheme.wireframeBlue.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final corners = <Offset>[];
    if (wallsDetected >= 1) {
      corners.add(Offset(cx - 120, cy + 80));
      corners.add(Offset(cx + 120, cy + 80));
    }
    if (wallsDetected >= 3) {
      corners.add(Offset(cx - 100, cy - 40));
    }
    if (wallsDetected >= 2) {
      corners.add(Offset(cx + 100, cy - 40));
    }

    for (final corner in corners) {
      canvas.drawCircle(corner, 4, cornerPaint);
      canvas.drawCircle(
        corner,
        8,
        Paint()
          ..color = AppTheme.wireframeBlue.withValues(alpha: 0.2)
          ..style = PaintingStyle.fill,
      );
    }
  }

  void _drawWall(Canvas canvas, Paint paint, Paint glowPaint,
      Offset start, Offset end, double phase) {
    canvas.drawLine(start, end, glowPaint);
    canvas.drawLine(start, end, paint);
  }

  void _drawVertical(Canvas canvas, Paint paint, Paint glowPaint,
      Offset start, Offset end, double phase) {
    final dashPaint = Paint()
      ..color = paint.color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(start, end, glowPaint);
    canvas.drawLine(start, end, dashPaint);
  }

  @override
  bool shouldRepaint(covariant _LiveWireframePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isScanning != isScanning ||
        oldDelegate.wallsDetected != wallsDetected;
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
