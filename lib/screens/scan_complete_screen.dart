import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_checkmark.dart';
import '../models/room_scan.dart';
import '../core/routes/app_routes.dart';

class ScanCompleteScreen extends StatefulWidget {
  final RoomScan? roomScan;

  const ScanCompleteScreen({
    super.key,
    this.roomScan,
  });

  @override
  State<ScanCompleteScreen> createState() => _ScanCompleteScreenState();
}

class _ScanCompleteScreenState extends State<ScanCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _textFade;
  late Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onCheckmarkComplete() {
    _fadeController.forward();
  }

  void _navigateToLabel() {
    final effectiveScan = widget.roomScan ?? (Get.arguments as RoomScan?);
    Get.offNamed(AppRoutes.roomLabel, arguments: effectiveScan);
  }

  @override
  Widget build(BuildContext context) {
    final scan = widget.roomScan ?? (Get.arguments as RoomScan?);
    final wallCount = scan?.walls.length ?? 4;
    final areaStr = scan?.area != null
        ? '${scan!.area!.toStringAsFixed(1)} m²'
        : '';

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            AnimatedCheckmark(
              size: 120,
              onComplete: _onCheckmarkComplete,
            ),

            const SizedBox(height: 32),

            AnimatedBuilder(
              animation: _textFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _textFade.value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - _textFade.value)),
                    child: Column(
                      children: [
                        Text(
                          'Scanning Completed',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          areaStr.isNotEmpty
                              ? 'Extracted $wallCount high-precision wall segments ($areaStr)'
                              : 'Press Done to categorize and label your room',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const Spacer(flex: 3),

            AnimatedBuilder(
              animation: _buttonFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _buttonFade.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _buttonFade.value)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _navigateToLabel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                            ),
                            elevation: 8,
                            shadowColor: AppTheme.primaryBlue.withValues(alpha: 0.5),
                          ),
                          child: const Text(
                            'Continue to Labelling',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 32),
          ],
        ),
      ),
    );
  }
}
