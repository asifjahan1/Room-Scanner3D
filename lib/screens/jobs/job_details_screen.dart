import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../controllers/dashboard_controller.dart';
import '../../core/routes/app_routes.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: PerfektTheme.textDark,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'JOB DETAILS',
            style: PerfektTheme.fontBold(
              17,
              color: PerfektTheme.textDark,
            ).copyWith(letterSpacing: 1.1),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PerfektTheme.surfaceGrey,
                  border: Border.all(
                    color: PerfektTheme.primaryBlue,
                    width: 1.5,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Navigate Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Foundation Pour –\nSector C",
                            style: PerfektTheme.fontBold(
                              24,
                              color: PerfektTheme.textDark,
                            ).copyWith(height: 1.15),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: PerfektTheme.textMedium,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Alexanderplatz 4, Berlin",
                                style: PerfektTheme.fontMedium(
                                  13,
                                  color: PerfektTheme.textMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 15,
                                color: PerfektTheme.textLight,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Start time 08:00 AM",
                                style: PerfektTheme.fontRegular(
                                  13,
                                  color: PerfektTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: PerfektTheme.borderLight),
                        boxShadow: PerfektTheme.cardShadow,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.near_me_outlined,
                          color: PerfektTheme.primaryBlue,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Zone Tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: PerfektTheme.surfaceGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Zone A – Plot 8–24",
                    style: PerfektTheme.fontSemiBold(
                      12,
                      color: PerfektTheme.textMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Safety Alert Card
                PerfektCard(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: const Color(0xFFFFFBEB),
                  borderColor: const Color(0xFFFEF3C7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFD97706),
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Safety Alert",
                              style: PerfektTheme.fontBold(
                                14,
                                color: const Color(0xFF92400E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "High-Wind Advisory: Secure loose scaffolding prior to concrete operations.",
                              style: PerfektTheme.fontRegular(
                                13,
                                color: const Color(0xFFB45309),
                              ).copyWith(height: 1.35),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Today's Work Card (Clickable to open My Day Timeline)
                PerfektCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  onTap: () => Get.toNamed(AppRoutes.myDayTimeline),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.assignment_rounded,
                          color: PerfektTheme.primaryBlue,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Work",
                              style: PerfektTheme.fontBold(
                                16,
                                color: PerfektTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "4 Tasks • 3h 45m estimated",
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Assigned Foreman Card
                PerfektCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: PerfektTheme.surfaceGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_pin_circle_outlined,
                          color: PerfektTheme.textDark,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Assigned Foreman",
                              style: PerfektTheme.fontBold(
                                16,
                                color: PerfektTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Lukas Weber • Site Lead",
                              style: PerfektTheme.fontRegular(
                                13,
                                color: PerfektTheme.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Site Layout Section
                Text(
                  "SITE LAYOUT & SENSOR RADAR",
                  style: PerfektTheme.fontSemiBold(
                    11,
                    color: PerfektTheme.textLight,
                  ).copyWith(letterSpacing: 1.2),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: PerfektTheme.radiusCard,
                    border: Border.all(color: PerfektTheme.borderLight),
                  ),
                  child: ClipRRect(
                    borderRadius: PerfektTheme.radiusCard,
                    child: Stack(
                      children: [
                        const AbsorbPointer(
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(52.5219, 13.4132),
                              zoom: 14,
                            ),
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            mapToolbarEnabled: false,
                            scrollGesturesEnabled: false,
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: PerfektTheme.primaryBlue,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: PerfektTheme.buttonShadow,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Sector C-4 Active",
                                  style: PerfektTheme.fontBold(
                                    13,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Start Shift Button
                PerfektButton(
                  label: "Start Shift",
                  icon: Icons.access_time_rounded,
                  height: 52,
                  backgroundColor: PerfektTheme.primaryBlueDark,
                  onPressed: () {
                    Get.back();

                    controller.changeTab(0);

                    if (!controller.isClockedIn.value) {
                      Future.delayed(const Duration(milliseconds: 250), () {
                        controller.toggleClockIn();
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(
                    0,
                    Icons.home_filled,
                    Icons.home_outlined,
                    'Home',
                    controller,
                    false,
                  ),
                  _buildNavItem(
                    1,
                    Icons.assignment_rounded,
                    Icons.assignment_outlined,
                    'Task',
                    controller,
                    true,
                  ),
                  _buildNavItem(
                    2,
                    Icons.handyman_rounded,
                    Icons.handyman_outlined,
                    'Tools',
                    controller,
                    false,
                  ),
                  _buildNavItem(
                    3,
                    Icons.chat_bubble_rounded,
                    Icons.chat_bubble_outline_rounded,
                    'Message',
                    controller,
                    false,
                  ),
                  _buildNavItem(
                    4,
                    Icons.menu_rounded,
                    Icons.menu_rounded,
                    'More',
                    controller,
                    false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
    DashboardController controller,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        controller.changeTab(index);
        Get.back();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.0 : 12.0,
          vertical: isSelected ? 8.0 : 6.0,
        ),
        decoration: BoxDecoration(
          color: isSelected ? PerfektTheme.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: PerfektTheme.primaryBlue.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 22,
              color: isSelected ? Colors.white : PerfektTheme.textLight,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: isSelected
                  ? PerfektTheme.fontBold(11, color: Colors.white)
                  : PerfektTheme.fontMedium(11, color: PerfektTheme.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
