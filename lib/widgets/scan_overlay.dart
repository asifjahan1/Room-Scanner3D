import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/room_scan.dart';
import 'live_room_minimap.dart';

/// Redesigned AR Scanning Overlay matching MeasureSquare / Apple RoomPlan UI aesthetic (Screenshot 2)
class ScanOverlay extends StatefulWidget {
  final VoidCallback? onDoneTap;
  final VoidCallback? onShutterTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onFlashTap;
  final bool isScanning;
  final bool isRecording;
  final String recordingDurationText;
  final double scanProgress;
  final int wallsDetected;
  final String guidanceMessage;
  final TrackingQuality trackingQuality;
  final List<String> warnings;

  const ScanOverlay({
    super.key,
    this.onDoneTap,
    this.onShutterTap,
    this.onSettingsTap,
    this.onFlashTap,
    this.isScanning = false,
    this.isRecording = false,
    this.recordingDurationText = '00:00',
    this.scanProgress = 0.0,
    this.wallsDetected = 0,
    this.guidanceMessage = '',
    this.trackingQuality = TrackingQuality.good,
    this.warnings = const [],
  });

  @override
  State<ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<ScanOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // Top Bar: Torch / Flash toggle on left, minimalist status in center, settings on right
        Positioned(
          top: topPadding + 10,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Torch / Flash toggle button (Top Left like Apple RoomPlan UI)
              _buildTopCircleButton(
                icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                onTap: () {
                  setState(() => _isFlashOn = !_isFlashOn);
                  widget.onFlashTap?.call();
                },
              ),
              // Compact status pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  border: Border.all(
                    color: widget.isRecording
                        ? AppTheme.dangerRed.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.25),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isRecording || widget.isScanning)
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.dangerRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.accentTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isRecording || widget.isScanning
                          ? 'SCANNING • ${widget.wallsDetected} CORNERS'
                          : 'READY TO SCAN',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Settings / Close button
              _buildTopCircleButton(
                icon: Icons.settings_rounded,
                onTap: widget.onSettingsTap,
              ),
            ],
          ),
        ),

        // Subtle guidance banner (only shows if tracking is lost or special guidance is needed)
        if (widget.warnings.isNotEmpty)
          Positioned(
            top: topPadding + 68,
            left: 32,
            right: 32,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.warningOrange.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.black, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.warnings.last,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Right-Side Manual Shutter Button with Counter Badge above it (Exact Screenshot 2 layout!)
        Positioned(
          right: 20,
          bottom: bottomPadding + 160,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Count badge above button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                ),
                child: Text(
                  '${widget.wallsDetected}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Classic White AR Point Shutter Button
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  widget.onShutterTap?.call();
                },
                child: Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Center: Floating Transparent 3D Dollhouse Model right above the violet "Done" button!
        Positioned(
          bottom: bottomPadding + 20,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Floating 3D extruded room model (no black box!)
              LiveRoomMiniMap(
                wallsDetected: widget.wallsDetected,
                isScanning: true, // Always show the glowing 3D architecture layout forming!
              ),
              const SizedBox(height: 16),
              // MeasureSquare / Apple RoomPlan violet-blue capsule "Done" button
              GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();
                  widget.onDoneTap?.call();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7483E7), // Exact Apple RoomPlan purple-indigo color
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7483E7).withValues(alpha: 0.45),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopCircleButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, color: Colors.white, size: 21),
      ),
    );
  }
}
