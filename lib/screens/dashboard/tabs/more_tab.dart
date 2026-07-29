import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header - Top App Bar
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9FF),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000), // rgba(0,0,0,0.04)
                    offset: Offset(0, 8),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.handyman, // Tools icon
                        color: Color(0xFF00418F),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "More",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          letterSpacing: -0.6,
                          color: Color(0xFF00418F),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Synced Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F3FC),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.sync_rounded,
                              color: Color(0xFF16A34A),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "SYNCED",
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 1.2,
                                color: Color(0xFF5C5F61),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Profile Avatar
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0x330058BC),
                            width: 2,
                          ), // rgba(0, 88, 188, 0.2)
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content Canvas
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Overview Section
                    const Text(
                      "Logged in as",
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.7,
                        color: Color(0xFF5C5F61),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Markus Steiner",
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color(0xFF191B22),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Senior Site Engineer • Team Werk-4",
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF5C5F61),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Navigation Tiles
                    _buildNavTile(
                      title: "New Lead",
                      icon: Icons.person_add_alt_1_outlined,
                      onTap: () => Get.toNamed(AppRoutes.leadDetails),
                    ),
                    const SizedBox(height: 16),

                    _buildNavTile(
                      title: "My Schedule",
                      icon: Icons.calendar_today_outlined,
                      onTap: () => Get.toNamed(AppRoutes.mySchedule),
                    ),
                    const SizedBox(height: 16),

                    _buildNavTile(
                      title: "Calendar",
                      icon: Icons.calendar_month_outlined,
                      onTap: () => Get.toNamed(AppRoutes.myCalendar),
                    ),
                    const SizedBox(height: 16),

                    _buildNavTile(
                      title: "Attendance History",
                      icon: Icons.history_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildNavTile(
                      title: "Availability",
                      icon: Icons.event_available_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildNavTile(
                      title: "Leave Requests",
                      icon: Icons.event_busy_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildNavTile(
                      title: "Profile & Settings",
                      icon: Icons.manage_accounts_outlined,
                      onTap: () => Get.toNamed(AppRoutes.profileAndSettings),
                    ),
                    const SizedBox(height: 16),

                    _buildNavTile(
                      title: "Device Connectivity",
                      icon: Icons.important_devices_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildNavTile(
                      title: "Offline Sync",
                      icon: Icons.cloud_done_outlined,
                      onTap: () => Get.toNamed(AppRoutes.syncComplete),
                    ),
                    const SizedBox(height: 16),

                    _buildNavTile(
                      title: "Help & Support",
                      icon: Icons.help_outline_rounded,
                      onTap: () {},
                    ),

                    const SizedBox(height: 24),
                    const Divider(
                      color: Color(0x1AC2C6D5),
                      height: 1,
                      thickness: 1,
                    ), // rgba(194, 198, 213, 0.1)
                    const SizedBox(height: 24),

                    _buildNavTile(
                      title: "Sign Out",
                      icon: Icons.logout_rounded,
                      isDestructive: true,
                      onTap: () => Get.offAllNamed(AppRoutes.welcome),
                    ),

                    // System Footer
                    const SizedBox(height: 48),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1E2EB),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "PERFEKTWERK OS V2.4.12-PRO",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              letterSpacing: 1.0,
                              color: Color(0xFF727784),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "MACHINE ID: PW-3401-GER",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              letterSpacing: 1.0,
                              color: Color(0x80727784), // 50% opacity
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final Color borderColor = isDestructive
        ? const Color(0x0DBA1A1A)
        : const Color(0x08000000);
    final Color iconBgColor = isDestructive
        ? const Color(0x1AFFDAD6)
        : const Color(0x0D0058BC);
    final Color primaryColor = isDestructive
        ? const Color(0xFFBA1A1A)
        : const Color(0xFF00418F);
    final Color textColor = isDestructive
        ? const Color(0xFFBA1A1A)
        : const Color(0xFF191B22);
    final Color chevronColor = isDestructive
        ? const Color(0x4DBA1A1A)
        : const Color(0xFFC2C6D5);

    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ), // rgba(0,0,0,0.05)
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 8),
            blurRadius: 20,
          ), // rgba(0,0,0,0.04)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: primaryColor, size: 24),
                    ),
                    const SizedBox(height: 16, width: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isDestructive
                      ? Icons.logout_rounded
                      : Icons.chevron_right_rounded,
                  color: chevronColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
