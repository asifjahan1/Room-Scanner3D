import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';
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
                // Main White Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: PerfektTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      // Glowing Green Checkmark Circle
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF10B981).withValues(alpha: 0.08),
                            ),
                          ),
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF10B981).withValues(alpha: 0.16),
                            ),
                          ),
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.check_rounded, color: Color(0xFF10B981), size: 32),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
      
                      // Title
                      Text(
                        "Request Sent",
                        style: PerfektTheme.fontBold(24, color: PerfektTheme.textDark),
                      ),
                      const SizedBox(height: 20),
                      
                      // Material Details
                      Text(
                        "MATERIAL DETAILS",
                        style: PerfektTheme.fontBold(10, color: PerfektTheme.textLight).copyWith(letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Concrete Mix",
                        style: PerfektTheme.fontBold(18, color: PerfektTheme.primaryBlue),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "12 Bags",
                        style: PerfektTheme.fontMedium(14, color: PerfektTheme.textMedium),
                      ),
                      const SizedBox(height: 24),
      
                      // Approval Status Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: PerfektTheme.surfaceGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_filled_rounded, size: 14, color: PerfektTheme.textMedium),
                            const SizedBox(width: 8),
                            Text(
                              "Waiting for supervisor approval",
                              style: PerfektTheme.fontMedium(12, color: PerfektTheme.textDark),
                            ),
                          ],
                        ),
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
                  onPressed: () => Get.until((route) => route.settings.name == AppRoutes.materialRequests || route.isFirst),
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
