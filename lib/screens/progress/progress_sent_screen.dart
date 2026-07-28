import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';

class ProgressSentScreen extends StatelessWidget {
  const ProgressSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: PerfektTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.handyman, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                'PerfektWerk OS',
                style: PerfektTheme.fontBold(16, color: PerfektTheme.textDark),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PerfektTheme.surfaceGrey,
                  border: Border.all(color: PerfektTheme.primaryBlue, width: 1.5),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // Glowing Green Checkmark Circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 136,
                      height: 136,
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
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
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
                        child: Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 48),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Title & Subtitle
                Text(
                  "Update sent",
                  style: PerfektTheme.fontBold(26, color: PerfektTheme.textDark),
                ),
                const SizedBox(height: 6),
                Text(
                  "Log successfully recorded for Site A-12",
                  style: PerfektTheme.fontRegular(14, color: PerfektTheme.textMedium),
                ),
                const SizedBox(height: 36),

                // Summary Card
                PerfektCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        icon: Icons.mic_rounded,
                        iconBgColor: const Color(0xFFEFF6FF),
                        iconColor: PerfektTheme.primaryBlue,
                        label: "INPUT TYPE",
                        value: "Voice update",
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(color: PerfektTheme.borderLight, height: 1),
                      ),
                      _buildSummaryRow(
                        icon: Icons.photo_library_rounded,
                        iconBgColor: PerfektTheme.surfaceGrey,
                        iconColor: PerfektTheme.textMedium,
                        label: "ATTACHMENTS",
                        value: "1 photo attached",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Back to task Button
                PerfektButton(
                  label: "Back to task",
                  height: 54,
                  fontSize: 16,
                  onPressed: () => Get.offNamedUntil(AppRoutes.taskDetail, (route) => route.settings.name == AppRoutes.taskDetail || route.isFirst),
                ),
                const SizedBox(height: 14),

                // Open my day secondary button
                GestureDetector(
                  onTap: () => Get.offAllNamed(AppRoutes.myDayTimeline),
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: PerfektTheme.borderLight),
                      boxShadow: PerfektTheme.cardShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today_rounded, color: PerfektTheme.primaryBlue, size: 19),
                        const SizedBox(width: 10),
                        Text(
                          "Open my day",
                          style: PerfektTheme.fontBold(15, color: PerfektTheme.primaryBlue),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: PerfektTheme.fontBold(11, color: PerfektTheme.textLight).copyWith(
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: PerfektTheme.fontBold(16, color: PerfektTheme.textDark),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
