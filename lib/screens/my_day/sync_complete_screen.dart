import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../widgets/perfekt/perfekt_button.dart';

class SyncCompleteScreen extends StatelessWidget {
  const SyncCompleteScreen({super.key});

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
                'PERFEKTWERK OS',
                style: PerfektTheme.fontBold(14, color: PerfektTheme.textDark).copyWith(
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Container(
                width: 34,
                height: 34,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Glowing green checkmark circle
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: PerfektTheme.successGreenBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFBBF7D0), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: PerfektTheme.successGreen.withValues(alpha: 0.2),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 54,
                      color: PerfektTheme.successGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Your work is up to date",
                  style: PerfektTheme.fontBold(26, color: PerfektTheme.textDark),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "All photos, measurements, and updates are safely stored.",
                    textAlign: TextAlign.center,
                    style: PerfektTheme.fontRegular(15, color: PerfektTheme.textMedium).copyWith(
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Stored Data List Card
                PerfektCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      _buildSyncItem(Icons.camera_alt_outlined, "6 Photos"),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(color: PerfektTheme.borderLight, height: 1),
                      ),
                      _buildSyncItem(Icons.straighten_rounded, "2 Measurements"),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(color: PerfektTheme.borderLight, height: 1),
                      ),
                      _buildSyncItem(Icons.playlist_add_check_rounded, "3 Updates"),
                    ],
                  ),
                ),
                const Spacer(),

                // Back to My Day Button
                PerfektButton(
                  label: "BACK TO MY DAY",
                  height: 52,
                  fontSize: 15,
                  onPressed: () => Get.back(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSyncItem(IconData icon, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: PerfektTheme.primaryBlue, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: PerfektTheme.fontBold(16, color: PerfektTheme.textDark),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: PerfektTheme.successGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 14),
        ),
      ],
    );
  }
}
