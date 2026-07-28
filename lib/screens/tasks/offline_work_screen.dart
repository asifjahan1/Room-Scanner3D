import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../widgets/perfekt/perfekt_button.dart';

class OfflineWorkScreen extends StatelessWidget {
  const OfflineWorkScreen({super.key});

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
                child: const Icon(
                  Icons.handyman,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'PERFEKTWERK OS',
                style: PerfektTheme.fontBold(
                  14,
                  color: PerfektTheme.textDark,
                ).copyWith(letterSpacing: 1.0),
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.wifi_off_rounded,
                color: PerfektTheme.textLight,
                size: 22,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // Offline Cloud Icon with Pause Badge
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 108,
                      height: 108,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF6FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.cloud_off_rounded,
                          size: 52,
                          color: PerfektTheme.primaryBlue,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: PerfektTheme.cardShadow,
                        ),
                        child: const Icon(
                          Icons.pause_circle_filled,
                          color: PerfektTheme.primaryBlue,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Title & Subtitle
                Text(
                  "You can keep working",
                  style: PerfektTheme.fontBold(
                    24,
                    color: PerfektTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "We've paused syncing until you're back online.",
                  textAlign: TextAlign.center,
                  style: PerfektTheme.fontRegular(
                    15,
                    color: PerfektTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 32),

                // Pending Items Card
                PerfektCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PENDING ITEMS TO SYNC",
                        style: PerfektTheme.fontBold(
                          11,
                          color: PerfektTheme.textLight,
                        ).copyWith(letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 18),
                      _buildPendingItem(
                        Icons.playlist_add_check_rounded,
                        "3 Updates",
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(
                          color: PerfektTheme.borderLight,
                          height: 1,
                        ),
                      ),
                      _buildPendingItem(Icons.camera_alt_outlined, "8 Photos"),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(
                          color: PerfektTheme.borderLight,
                          height: 1,
                        ),
                      ),
                      _buildPendingItem(
                        Icons.straighten_rounded,
                        "2 Measurements",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Reassurance Note
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "All your work is saved securely. Everything will sync automatically when you're back online.",
                    textAlign: TextAlign.center,
                    style: PerfektTheme.fontRegular(
                      13,
                      color: PerfektTheme.textLight,
                    ).copyWith(height: 1.45),
                  ),
                ),
                const SizedBox(height: 36),

                // Back to My Task Button
                PerfektButton(
                  label: "Back to my task",
                  icon: Icons.arrow_back_rounded,
                  height: 52,
                  fontSize: 16,
                  onPressed: () => Get.back(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingItem(IconData icon, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: PerfektTheme.surfaceGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: PerfektTheme.textDark, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: PerfektTheme.fontBold(15, color: PerfektTheme.textDark),
          ),
        ),
        const Icon(
          Icons.access_time_rounded,
          color: PerfektTheme.textLight,
          size: 18,
        ),
      ],
    );
  }
}
