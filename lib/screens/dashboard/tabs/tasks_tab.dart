import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/perfekt_theme.dart';
import '../../../../widgets/perfekt/perfekt_card.dart';
import '../../../../widgets/perfekt/perfekt_button.dart';
import '../../../../controllers/dashboard_controller.dart';
import '../../../../core/routes/app_routes.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                Container(
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
              ],
            ),
            const SizedBox(height: 24),

            // Subtitle Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "NEXT TASKS",
                  style: PerfektTheme.fontSemiBold(12, color: PerfektTheme.textLight).copyWith(
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  "3 ACTIVE SITES",
                  style: PerfektTheme.fontBold(12, color: PerfektTheme.primaryBlue).copyWith(
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Job Card 1: Skyline Apartments
            _buildJobCard(
              title: "Skyline Apartments",
              subtitle: "Zone B – Berlin",
              statusBadge: "ACTIVE",
              badgeBg: const Color(0xFFEFF6FF),
              badgeColor: PerfektTheme.primaryBlue,
              icon: Icons.apartment_rounded,
              iconBg: const Color(0xFFEFF6FF),
              iconColor: PerfektTheme.primaryBlue,
              label: "DISTANCE",
              value: "12 mins away",
              trailingSymbol: Icons.construction_rounded,
              buttonText: "View Job",
              buttonIcon: Icons.arrow_forward_rounded,
              isSecondaryButton: false,
              onPressed: () => Get.toNamed(AppRoutes.jobDetails),
            ),
            const SizedBox(height: 16),

            // Job Card 2: North Station Hub
            _buildJobCard(
              title: "North Station Hub",
              subtitle: "Sector 4 – Hamburg",
              statusBadge: "PENDING",
              badgeBg: const Color(0xFFF1F5F9),
              badgeColor: PerfektTheme.textMedium,
              icon: Icons.hub_outlined,
              iconBg: const Color(0xFFFFF7ED),
              iconColor: const Color(0xFFEA580C),
              label: "TIME",
              value: "Starts 08:30",
              trailingSymbol: Icons.engineering_rounded,
              buttonText: "Start Shift",
              buttonIcon: Icons.schedule_rounded,
              isSecondaryButton: true,
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
              subtitle: "Sector 12 – Munich",
              statusBadge: "LOCATION",
              badgeBg: const Color(0xFFEFF6FF),
              badgeColor: PerfektTheme.primaryBlue,
              icon: Icons.park_outlined,
              iconBg: const Color(0xFFF0FDF4),
              iconColor: PerfektTheme.successGreen,
              label: "DISTANCE",
              value: "0.0m – On Site",
              trailingSymbol: Icons.handyman_rounded,
              buttonText: "View Job",
              buttonIcon: Icons.arrow_forward_rounded,
              isSecondaryButton: false,
              onPressed: () => Get.toNamed(AppRoutes.jobDetails),
            ),
            const SizedBox(height: 24),
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
    required String label,
    required String value,
    required IconData trailingSymbol,
    required String buttonText,
    required IconData buttonIcon,
    required bool isSecondaryButton,
    required VoidCallback onPressed,
  }) {
    return PerfektCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: PerfektTheme.fontBold(18, color: PerfektTheme.textDark),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: PerfektTheme.textLight),
                        const SizedBox(width: 3),
                        Text(
                          subtitle,
                          style: PerfektTheme.fontRegular(13, color: PerfektTheme.textMedium),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusBadge,
                  style: PerfektTheme.fontBold(11, color: badgeColor).copyWith(
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: PerfektTheme.borderLight, height: 1),
          const SizedBox(height: 16),
          // Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: PerfektTheme.fontSemiBold(10, color: PerfektTheme.textLight).copyWith(
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: PerfektTheme.fontBold(15, color: PerfektTheme.textDark),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PerfektTheme.surfaceGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(trailingSymbol, color: PerfektTheme.textMedium, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Button Action
          PerfektButton(
            label: buttonText,
            trailingIcon: !isSecondaryButton ? buttonIcon : null,
            icon: isSecondaryButton ? buttonIcon : null,
            height: 48,
            backgroundColor: isSecondaryButton ? PerfektTheme.surfaceDarkGrey : PerfektTheme.primaryBlue,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
