import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';

class MaterialRequestSentScreen extends StatelessWidget {
  const MaterialRequestSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Glowing Green Checkmark Circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF10B981).withValues(alpha: 0.08),
                      ),
                    ),
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF10B981).withValues(alpha: 0.16),
                      ),
                    ),
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.check_rounded, color: Color(0xFF10B981), size: 46),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Title & Subtitle
                Text(
                  "Request Sent",
                  style: PerfektTheme.fontBold(26, color: PerfektTheme.textDark),
                ),
                const SizedBox(height: 8),
                Text(
                  "12 x Timber Slats 200x50",
                  style: PerfektTheme.fontBold(18, color: PerfektTheme.primaryBlue),
                ),
                const SizedBox(height: 18),

                // Approval Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: PerfektTheme.surfaceGrey,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_filled_rounded, size: 16, color: PerfektTheme.textMedium),
                      const SizedBox(width: 8),
                      Text(
                        "Waiting for supervisor approval",
                        style: PerfektTheme.fontMedium(13, color: PerfektTheme.textDark),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Back to List Button
                PerfektButton(
                  label: "BACK TO LIST",
                  icon: Icons.arrow_back_rounded,
                  height: 54,
                  fontSize: 15,
                  onPressed: () => Get.offUntil(GetPageRoute(page: () => Get.find<Widget>(tag: 'dashboard')), (route) => route.isFirst),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
