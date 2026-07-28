import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../controllers/dashboard_controller.dart';

class ShiftEndedScreen extends StatelessWidget {
  const ShiftEndedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Success checkmark icon badge
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: PerfektTheme.successGreenBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFBBF7D0), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: PerfektTheme.successGreen.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 56,
                      color: PerfektTheme.successGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Shift Ended",
                  style: PerfektTheme.fontBold(30, color: PerfektTheme.textDark),
                ),
                const SizedBox(height: 8),
                Text(
                  "All data synced. Enjoy your evening!",
                  style: PerfektTheme.fontRegular(16, color: PerfektTheme.textMedium),
                ),
                const SizedBox(height: 36),

                // Shift Summary Box
                PerfektCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        "SHIFT SUMMARY",
                        style: PerfektTheme.fontSemiBold(11, color: PerfektTheme.textLight).copyWith(
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => Text(
                        controller.lastShiftSummary.value,
                        style: PerfektTheme.fontBold(44, color: PerfektTheme.textDark),
                      )),
                      const SizedBox(height: 8),
                      Text(
                        "Berlin Sector C-4 • Worker",
                        style: PerfektTheme.fontMedium(14, color: PerfektTheme.textMedium),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Action Buttons
                PerfektButton(
                  label: "Back to Home",
                  height: 52,
                  fontSize: 16,
                  onPressed: () => controller.backToHomeFromShift(),
                ),
                const SizedBox(height: 12),
                PerfektButton(
                  label: "View My Day",
                  type: PerfektButtonType.outline,
                  height: 52,
                  fontSize: 16,
                  onPressed: () => controller.viewMyDayFromShift(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined, size: 14, color: PerfektTheme.textLight),
                    const SizedBox(width: 4),
                    Text(
                      "ISO 27001   |   Vault-Shield Sync",
                      style: PerfektTheme.fontMedium(11, color: PerfektTheme.textLight),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
