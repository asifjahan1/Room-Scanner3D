import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';

class VoiceUpdateScreen extends StatelessWidget {
  const VoiceUpdateScreen({super.key});

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
                child: const Icon(Icons.mic, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                'VOICE UPDATE',
                style: PerfektTheme.fontBold(
                  15,
                  color: PerfektTheme.textDark,
                ).copyWith(letterSpacing: 1.1),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: PerfektTheme.textDark,
                size: 24,
              ),
              onPressed: () => Get.back(),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Task Title Pill Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.construction_rounded,
                        size: 15,
                        color: PerfektTheme.primaryBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Install Wall Framing",
                        style: PerfektTheme.fontBold(
                          13,
                          color: PerfektTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Glowing Sound Wave Circle with Mic
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PerfektTheme.primaryBlue.withValues(alpha: 0.06),
                      ),
                    ),
                    Container(
                      width: 146,
                      height: 146,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PerfektTheme.primaryBlue.withValues(alpha: 0.12),
                      ),
                    ),
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PerfektTheme.primaryBlue,
                        boxShadow: [
                          BoxShadow(
                            color: PerfektTheme.primaryBlue.withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.mic_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Timer Display
                Text(
                  "00:15",
                  style: PerfektTheme.fontBold(
                    34,
                    color: PerfektTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Recording...",
                      style: PerfektTheme.fontMedium(
                        14,
                        color: PerfektTheme.textMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Pause & Cancel Pills
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPillAction(
                      icon: Icons.pause_rounded,
                      iconColor: PerfektTheme.primaryBlue,
                      label: "Pause",
                      onTap: () => Get.snackbar(
                        'Recording Paused',
                        'Audio transcript temporarily paused.',
                        snackPosition: SnackPosition.TOP,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildPillAction(
                      icon: Icons.delete_outline_rounded,
                      iconColor: const Color(0xFFEF4444),
                      label: "Cancel",
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
                const Spacer(),

                // Live Transcript Card
                PerfektCard(
                  padding: const EdgeInsets.all(20),
                  borderColor: const Color(0xFFBFDBFE),
                  backgroundColor: const Color(0xFFF8FAFC),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                size: 16,
                                color: PerfektTheme.primaryBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Live Transcript",
                                style: PerfektTheme.fontBold(
                                  12,
                                  color: PerfektTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.graphic_eq_rounded,
                            size: 18,
                            color: PerfektTheme.primaryBlue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: PerfektTheme.fontRegular(
                            15,
                            color: PerfektTheme.textDark,
                          ).copyWith(height: 1.45),
                          children: [
                            const TextSpan(text: '"Wall framing '),
                            TextSpan(
                              text: '65% complete. ',
                              style: PerfektTheme.fontBold(
                                15,
                                color: PerfektTheme.primaryBlue,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  'Waiting for more studs to finish the laundry room corner..."',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Send Update Button
                PerfektButton(
                  label: "Send Update",
                  trailingIcon: Icons.send_rounded,
                  height: 52,
                  fontSize: 16,
                  onPressed: () => Get.toNamed(AppRoutes.offlineWork),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillAction({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: PerfektTheme.borderLight),
          boxShadow: PerfektTheme.cardShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: PerfektTheme.fontSemiBold(
                13,
                color: PerfektTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
