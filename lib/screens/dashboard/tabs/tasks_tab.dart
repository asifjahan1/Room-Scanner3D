import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/dashboard_controller.dart';
import '../../../../core/routes/app_routes.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header - Top Navigation Anchor
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9FF),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000), // 5% opacity black
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.build_rounded, // Best match for crossed tools
                        color: Color(0xFF00418F),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'PERFEKTWERK OS',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          letterSpacing: 1.2,
                          color: Color(0xFF00418F),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE1E2EB),
                      border: Border.all(color: Colors.white, width: 2),
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
            ),

            // 2. Main - Content Canvas
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search & Filter Bar / Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "NEXT TASKS",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 0.7,
                            color: Color(0xFF727784),
                          ),
                        ),
                        Text(
                          "3 ACTIVE SITES",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 0.7,
                            color: Color(0xFF00418F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Job Card 1: Skyline Apartments
                    _buildJobCard(
                      title: "Skyline Apartments",
                      subtitle: "Zone B - Berlin",
                      statusBadge: "ACTIVE",
                      badgeBg: const Color(0x1A00418F), // rgba(0, 65, 143, 0.1)
                      badgeColor: const Color(0xFF00418F),
                      icon: Icons.business_rounded,
                      iconBg: const Color(0x1A0058BC), // rgba(0, 88, 188, 0.1)
                      iconColor: const Color(0xFF00418F),
                      infoLabel1: "DISTANCE",
                      infoValue1: "12 mins away",
                      infoLabel2: "EQUIPMENT",
                      infoIcon2: Icons.precision_manufacturing_rounded,
                      infoIconColor2: const Color(0xFF00418F),
                      buttonText: "View Job",
                      buttonIcon: Icons.arrow_forward_rounded,
                      buttonBg: const Color(0xFF0058BC),
                      buttonTextColor: const Color(0xFFC3D4FF),
                      onPressed: () => Get.toNamed(AppRoutes.jobDetails),
                    ),
                    const SizedBox(height: 16),

                    // Job Card 2: North Station Hub
                    _buildJobCard(
                      title: "North Station Hub",
                      subtitle: "Sector 4 - Hamburg",
                      statusBadge: "PENDING",
                      badgeBg: const Color(0xFFE0E3E5),
                      badgeColor: const Color(0xFF5C5F61),
                      icon: Icons.hub_outlined,
                      iconBg: const Color(0x1A9E3D00), // rgba(158, 61, 0, 0.1)
                      iconColor: const Color(0xFF782C00),
                      infoLabel1: "TIME",
                      infoValue1: "Starts 08:30",
                      infoLabel2: "SAFETY",
                      infoIcon2: Icons.engineering_rounded,
                      infoIconColor2: const Color(0xFF782C00),
                      buttonText: "Start Shift",
                      buttonIcon: Icons.play_circle_outline_rounded,
                      buttonBg: const Color(0xFF00418F),
                      buttonTextColor: Colors.white,
                      onPressed: () {
                        controller.changeTab(0);
                        if (!controller.isClockedIn.value) {
                          controller.toggleClockIn();
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Job Card 3: Riviera Park
                    _buildJobCard(
                      title: "Riviera Park",
                      subtitle: "Site 12 - Munich",
                      statusBadge: "AT LOCATION",
                      badgeBg: const Color(0x1A00418F),
                      badgeColor: const Color(0xFF00418F),
                      icon: Icons.architecture_rounded,
                      iconBg: const Color(0x1A0058BC),
                      iconColor: const Color(0xFF00418F),
                      infoLabel1: "DISTANCE",
                      infoValue1: "50m - On Site",
                      infoLabel2: "TYPE",
                      infoIcon2: Icons.build_rounded,
                      infoIconColor2: const Color(0xFF00418F),
                      buttonText: "View Job",
                      buttonIcon: Icons.arrow_forward_rounded,
                      buttonBg: const Color(0xFF0058BC),
                      buttonTextColor: const Color(0xFFC3D4FF),
                      onPressed: () => Get.toNamed(AppRoutes.jobDetails),
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

  Widget _buildJobCard({
    required String title,
    required String subtitle,
    required String statusBadge,
    required Color badgeBg,
    required Color badgeColor,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String infoLabel1,
    required String infoValue1,
    required String infoLabel2,
    required IconData infoIcon2,
    required Color infoIconColor2,
    required String buttonText,
    required IconData buttonIcon,
    required Color buttonBg,
    required Color buttonTextColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x0D000000)), // 0.05 opacity
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // 0.04 opacity
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          // Row 1: Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 1.25,
                        color: Color(0xFF191B22),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: Color(0xFF424753),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xFF424753),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  statusBadge,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: Color(0x4DC2C6D5),
              height: 1,
              thickness: 1,
            ), // rgba(194, 198, 213, 0.3)
          ),

          // Row 2: Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    infoLabel1,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: Color(0xFF727784),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    infoValue1,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF191B22),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    infoLabel2,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: Color(0xFF727784),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Icon(infoIcon2, color: infoIconColor2, size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Button
          Container(
            height: 64,
            width: double.infinity,
            decoration: BoxDecoration(
              color: buttonBg,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x400058BC), // 0.25 opacity
                  offset: Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: buttonTextColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(buttonIcon, color: buttonTextColor, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
