import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/perfekt_theme.dart';
import '../../../../widgets/perfekt/perfekt_card.dart';
import '../../../../core/routes/app_routes.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Title Header
            Text(
              "More",
              style: PerfektTheme.fontBold(24, color: PerfektTheme.primaryBlue),
            ),
            const SizedBox(height: 18),

            // Profile Header Card (Markus Steiner)
            PerfektCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: PerfektTheme.primaryBlue,
                            width: 2,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Markus Steiner",
                          style: PerfektTheme.fontBold(
                            18,
                            color: PerfektTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Senior Field Engineer @ Team Photo A",
                          style: PerfektTheme.fontRegular(
                            13,
                            color: PerfektTheme.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: PerfektTheme.textLight,
                    size: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu Items Card Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: PerfektTheme.radiusCard,
                border: Border.all(color: PerfektTheme.borderLight),
                boxShadow: PerfektTheme.cardShadow,
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_add_alt_1_outlined,
                    title: "New Lead",
                    subtitle: "Capture lead details & voice requirements",
                    onTap: () => Get.snackbar(
                      "New Lead",
                      "Capture lead details with audio dictation active.",
                      snackPosition: SnackPosition.TOP,
                    ),
                  ),
                  _buildDivider(),

                  _buildMenuItem(
                    icon: Icons.calendar_today_outlined,
                    title: "My Schedule",
                    subtitle: "Weekly assignments & Skyline Phase 2 shift",
                    onTap: () => Get.toNamed(AppRoutes.mySchedule),
                  ),
                  _buildDivider(),

                  // Highlighted Calendar Item
                  _buildMenuItem(
                    icon: Icons.calendar_month_rounded,
                    title: "Calendar",
                    subtitle: "Dynamic date scheduling & event logic",
                    iconColor: PerfektTheme.primaryBlue,
                    isHighlighted: true,
                    onTap: () => Get.toNamed(AppRoutes.myCalendar),
                  ),
                  _buildDivider(),

                  _buildMenuItem(
                    icon: Icons.history_rounded,
                    title: "Attendance History",
                    subtitle: "42 hours worked • Verified timesheet",
                    onTap: () => Get.snackbar(
                      "Attendance History",
                      "Summary: 42h worked of 168h monthly target.",
                      snackPosition: SnackPosition.TOP,
                    ),
                  ),
                  _buildDivider(),

                  _buildMenuItem(
                    icon: Icons.event_available_rounded,
                    title: "Availability",
                    subtitle: "Set weekly status (Available / Half / Off)",
                    onTap: () => Get.snackbar(
                      "Availability",
                      "Status set to 'Available' for October 21-25.",
                      snackPosition: SnackPosition.TOP,
                    ),
                  ),
                  _buildDivider(),

                  _buildMenuItem(
                    icon: Icons.beach_access_rounded,
                    title: "Leave Requests",
                    subtitle:
                        "Current balance: 12 Days • Vacation & Sick leave",
                    onTap: () => Get.snackbar(
                      "Leave Requests",
                      "Current leave balance: 12 Days available.",
                      snackPosition: SnackPosition.TOP,
                    ),
                  ),
                  _buildDivider(),

                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: "Profile & Settings",
                    subtitle: "Personal profile, security & app configurations",
                    onTap: () => Get.toNamed(AppRoutes.profileAndSettings),
                  ),
                  _buildDivider(),

                  _buildMenuItem(
                    icon: Icons.bluetooth_connected_rounded,
                    title: "Device Connectivity",
                    subtitle: "Leica D1 & Laser Measure Pro connected",
                    onTap: () => Get.snackbar(
                      "Device Connectivity",
                      "Laser Measure Pro connected via Bluetooth.",
                      snackPosition: SnackPosition.TOP,
                    ),
                  ),
                  _buildDivider(),

                  _buildMenuItem(
                    icon: Icons.cloud_sync_outlined,
                    title: "Offline Sync",
                    subtitle: "Device synced (2.4 GB) • Vault-Shield protocol",
                    onTap: () => Get.toNamed(AppRoutes.syncComplete),
                  ),
                  _buildDivider(),

                  _buildMenuItem(
                    icon: Icons.support_agent_rounded,
                    title: "Help & Support",
                    subtitle: "Submit support ticket & live engineering chat",
                    onTap: () => Get.snackbar(
                      "Help & Support",
                      "Live support specialist ready.",
                      snackPosition: SnackPosition.TOP,
                    ),
                  ),
                  _buildDivider(),

                  _buildMenuItem(
                    icon: Icons.logout_rounded,
                    title: "Sign Out",
                    subtitle: "Return to workspace authentication",
                    isDestructive: true,
                    onTap: () => Get.offAllNamed(AppRoutes.welcome),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 64,
      endIndent: 20,
      color: Color(0xFFF1F5F9),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    bool isHighlighted = false,
    bool isDestructive = false,
  }) {
    final effectiveColor = isDestructive
        ? PerfektTheme.alertCritical
        : (isHighlighted ? PerfektTheme.primaryBlue : PerfektTheme.textDark);

    return InkWell(
      onTap: onTap,
      borderRadius: PerfektTheme.radiusCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDestructive
                    ? const Color(0xFFFEE2E2)
                    : (isHighlighted
                          ? const Color(0xFFEFF6FF)
                          : PerfektTheme.surfaceGrey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: isDestructive
                      ? PerfektTheme.alertCritical
                      : (iconColor ??
                            (isHighlighted
                                ? PerfektTheme.primaryBlue
                                : PerfektTheme.textMedium)),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: PerfektTheme.fontBold(15, color: effectiveColor),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: PerfektTheme.fontRegular(
                      12,
                      color: PerfektTheme.textLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive
                  ? PerfektTheme.alertCritical
                  : PerfektTheme.textLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
