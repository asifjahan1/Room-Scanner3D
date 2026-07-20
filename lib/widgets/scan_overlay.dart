import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Scanning overlay UI elements shown on top of the camera/AR view
class ScanOverlay extends StatefulWidget {
  final VoidCallback? onDoneTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onFlashTap;
  final bool isScanning;
  final double scanProgress;
  final int wallsDetected;

  const ScanOverlay({
    super.key,
    this.onDoneTap,
    this.onSettingsTap,
    this.onFlashTap,
    this.isScanning = false,
    this.scanProgress = 0.0,
    this.wallsDetected = 0,
  });

  @override
  State<ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<ScanOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top bar - Settings & Flash
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Settings button
              _buildIconButton(
                icon: Icons.settings,
                onTap: widget.onSettingsTap,
              ),
              // Scan info
              if (widget.isScanning)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    border: Border.all(
                      color: AppTheme.wireframeGlow.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.scannerGreen,
                          shape: BoxShape.circle,
                          boxShadow: AppTheme.glowShadow(AppTheme.scannerGreen),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Scanning • ${widget.wallsDetected} walls',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              // Flash button
              _buildIconButton(
                icon: Icons.flash_off,
                onTap: widget.onFlashTap,
              ),
            ],
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 24,
          left: 0,
          right: 0,
          child: Column(
            children: [
              // Scan progress indicator
              if (widget.isScanning && widget.scanProgress > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: widget.scanProgress,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.accentTeal,
                        ),
                        minHeight: 4,
                      ),
                    ),
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 80), // Spacer for centering

                  // Capture/Record button
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: widget.isScanning ? _pulseAnimation.value : 1.0,
                        child: _buildCaptureButton(),
                      );
                    },
                  ),

                  const SizedBox(width: 20),

                  // Done button
                  _buildDoneButton(),
                ],
              ),
            ],
          ),
        ),

        // Scanning guide overlay
        if (!widget.isScanning)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.view_in_ar,
                    color: Colors.white70,
                    size: 40,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Point at a room to start scanning',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Slowly move around the room',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.scanButtonOuter,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: widget.isScanning
                  ? AppTheme.dangerRed
                  : AppTheme.scanButtonInner,
              shape: BoxShape.circle,
            ),
            child: widget.isScanning
                ? const Icon(Icons.stop, color: Colors.white, size: 28)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return GestureDetector(
      onTap: widget.onDoneTap,
      child: Container(
        width: 60,
        height: 36,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          boxShadow: [
            BoxShadow(
              color: AppTheme.doneButtonBg.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Done',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Wireframe visualization painter for demo/preview
class WireframePainter extends CustomPainter {
  final double progress;
  final Color wireframeColor;

  WireframePainter({
    this.progress = 1.0,
    this.wireframeColor = AppTheme.wireframeWhite,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = wireframeColor.withValues(alpha: 0.7 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final glowPaint = Paint()
      ..color = AppTheme.wireframeGlow.withValues(alpha: 0.3 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Draw a sample room wireframe (for preview purposes)
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width * 0.6;
    final h = size.height * 0.7;

    // Floor rectangle
    final floorPath = Path()
      ..moveTo(cx - w / 2, cy + h / 4)
      ..lineTo(cx + w / 2, cy + h / 4)
      ..lineTo(cx + w / 3, cy - h / 8)
      ..lineTo(cx - w / 3, cy - h / 8)
      ..close();

    // Ceiling rectangle (perspective)
    final ceilPath = Path()
      ..moveTo(cx - w / 3, cy - h / 8)
      ..lineTo(cx + w / 3, cy - h / 8)
      ..lineTo(cx + w / 4, cy - h / 2.5)
      ..lineTo(cx - w / 4, cy - h / 2.5)
      ..close();

    // Vertical edges
    final verticals = Path()
      ..moveTo(cx - w / 2, cy + h / 4)
      ..lineTo(cx - w / 3, cy - h / 8)
      ..moveTo(cx + w / 2, cy + h / 4)
      ..lineTo(cx + w / 3, cy - h / 8)
      ..moveTo(cx - w / 3, cy - h / 8)
      ..lineTo(cx - w / 4, cy - h / 2.5)
      ..moveTo(cx + w / 3, cy - h / 8)
      ..lineTo(cx + w / 4, cy - h / 2.5);

    // Draw with glow
    canvas.drawPath(floorPath, glowPaint);
    canvas.drawPath(ceilPath, glowPaint);
    canvas.drawPath(verticals, glowPaint);

    // Draw crisp lines
    canvas.drawPath(floorPath, paint);
    canvas.drawPath(ceilPath, paint);
    canvas.drawPath(verticals, paint);

    // Add some detail lines (furniture outlines)
    final detailPaint = Paint()
      ..color = wireframeColor.withValues(alpha: 0.4 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Cabinet-like rectangle
    final cabinet = Path()
      ..addRect(Rect.fromLTWH(
        cx - w / 4,
        cy - h / 10,
        w / 3,
        h / 5,
      ));
    canvas.drawPath(cabinet, detailPaint);

    // Corner dots
    final dotPaint = Paint()
      ..color = AppTheme.wireframeBlue.withValues(alpha: 0.6 * progress)
      ..style = PaintingStyle.fill;

    final corners = [
      Offset(cx - w / 2, cy + h / 4),
      Offset(cx + w / 2, cy + h / 4),
      Offset(cx - w / 3, cy - h / 8),
      Offset(cx + w / 3, cy - h / 8),
    ];

    for (final corner in corners) {
      canvas.drawCircle(corner, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant WireframePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
