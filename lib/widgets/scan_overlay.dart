import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/room_scan.dart';
import 'live_room_minimap.dart';

/// Scanning overlay UI elements shown on top of the continuous video capture stream
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
    return Stack(
      children: [
        // Top bar - Settings, Live Recording Timer Badge & Flash
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
              // Video recording / scan status indicator badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  border: Border.all(
                    color: widget.isRecording
                        ? AppTheme.dangerRed.withValues(alpha: 0.8)
                        : Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: widget.isRecording
                      ? [
                          BoxShadow(
                            color: AppTheme.dangerRed.withValues(alpha: 0.35),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isRecording)
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 10,
                              height: 10,
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
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppTheme.accentTeal,
                          shape: BoxShape.circle,
                          boxShadow: AppTheme.glowShadow(AppTheme.accentTeal),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isRecording
                          ? 'REC ${widget.recordingDurationText} • ${widget.wallsDetected} walls'
                          : 'Standby • Ready to Scan',
                      style: TextStyle(
                        color: widget.isRecording
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              // Flash button
              _buildIconButton(icon: Icons.flash_off, onTap: widget.onFlashTap),
            ],
          ),
        ),

        // Tracking quality warning & guidance banners
        if (widget.isRecording)
          Positioned(
            top: MediaQuery.of(context).padding.top + 68,
            left: 20,
            right: 20,
            child: Column(
              children: [
                if (widget.trackingQuality != TrackingQuality.good ||
                    widget.warnings.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.warningOrange.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.black,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.warnings.isNotEmpty
                                ? widget.warnings.last
                                : (widget.trackingQuality ==
                                          TrackingQuality.limited
                                      ? 'Tracking limited. Move slower or point towards textured walls.'
                                      : 'Tracking lost. Hold phone steady.'),
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
                if (widget.guidanceMessage.isNotEmpty &&
                    widget.warnings.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      border: Border.all(
                        color: AppTheme.accentTeal.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      widget.guidanceMessage,
                      style: const TextStyle(
                        color: AppTheme.accentTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Live 3D Room Mini-Map Card (Apple RoomPlan style bottom-left placement)
        if (widget.isRecording || widget.isScanning)
          Positioned(
            left: 20,
            bottom: MediaQuery.of(context).padding.bottom + 120,
            child: LiveRoomMiniMap(
              wallsDetected: widget.wallsDetected,
              isScanning: widget.isRecording || widget.isScanning,
            ),
          ),

        // Bottom continuous recording controls
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 24,
          left: 0,
          right: 0,
          child: Column(
            children: [
              // Scan progress indicator
              if (widget.isRecording && widget.scanProgress > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: widget.scanProgress,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.accentTeal,
                            ),
                            minHeight: 5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Capturing geometry • Tap Stop when done',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 110,
                  ), // Spacer to center main shutter button
                  // Capture/Record Shutter button
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale:
                            (widget.isRecording || widget.isScanning) &&
                                widget.trackingQuality == TrackingQuality.good
                            ? 1.0 + (_pulseAnimation.value - 1.0) * 0.4
                            : 1.0,
                        child: _buildCaptureButton(),
                      );
                    },
                  ),

                  const SizedBox(width: 20),

                  // Done / Stop button (prominent when scanning)
                  _buildDoneButton(),
                ],
              ),
            ],
          ),
        ),

        // Scanning guide overlay when idle (before user starts continuous record)
        if (!widget.isRecording && !widget.isScanning)
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(
                  color: AppTheme.accentTeal.withValues(alpha: 0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentTeal.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.videocam_rounded,
                      color: AppTheme.accentTeal,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Start Scanning from a Corner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Point your camera towards any room corner or wall intersection. Tap Record at the bottom to start seamless continuous 3D room capture.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppTheme.accentTeal.withValues(alpha: 0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Continuous video-style scanning',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIconButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: widget.onShutterTap,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isRecording ? Colors.white : AppTheme.scanButtonOuter,
            width: 4.5,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (widget.isRecording
                          ? AppTheme.dangerRed
                          : AppTheme.accentTeal)
                      .withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: widget.isRecording ? 36 : 58,
            height: widget.isRecording ? 36 : 58,
            decoration: BoxDecoration(
              color: widget.isRecording
                  ? AppTheme.dangerRed
                  : AppTheme.scanButtonInner,
              borderRadius: widget.isRecording
                  ? BorderRadius.circular(8) // Square stop icon when recording
                  : BorderRadius.circular(30),
            ),
            child: !widget.isRecording
                ? const Icon(
                    Icons.fiber_manual_record,
                    color: AppTheme.dangerRed,
                    size: 36,
                  )
                : const Icon(Icons.stop_rounded, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    if (!widget.isRecording && !widget.isScanning) {
      return const SizedBox(width: 90);
    }

    return GestureDetector(
      onTap: widget.onDoneTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.dangerRed,
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          boxShadow: [
            BoxShadow(
              color: AppTheme.dangerRed.withValues(alpha: 0.45),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_rounded, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              'Stop Scan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
