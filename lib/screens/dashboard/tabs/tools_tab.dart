import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/perfekt_theme.dart';
import '../../../../controllers/dashboard_controller.dart';
import '../../../../core/routes/app_routes.dart';

/// Data model for Measurement Grid Items
class MeasurementItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  MeasurementItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

/// Tools tab in PerfektWerk OS (Matching Figma Measurement Scan flow).
/// Dynamically generated grid for scalability and consistency.
class ToolsTab extends StatelessWidget {
  const ToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    // Dynamically defined list of measurement tools
    final List<MeasurementItem> measurementItems = [
      MeasurementItem(
        label: "Wall",
        icon: Icons.align_vertical_center_rounded,
        onTap: () => controller.launchLiDARScanner("Wall"),
      ),
      MeasurementItem(
        label: "Floor",
        icon: Icons.layers_outlined,
        onTap: () => controller.launchLiDARScanner("Floor"),
      ),
      MeasurementItem(
        label: "Ceiling",
        icon: Icons.vertical_align_top_rounded,
        onTap: () => controller.launchLiDARScanner("Ceiling"),
      ),
      MeasurementItem(
        label: "Opening",
        icon: Icons.crop_free_rounded,
        onTap: () => controller.launchLiDARScanner("Opening"),
      ),
      MeasurementItem(
        label: "Room",
        icon: Icons.view_in_ar_rounded,
        onTap: () => controller.launchLiDARScanner("Room"),
      ),
      MeasurementItem(
        label: "Trench",
        icon: Icons.view_headline_rounded,
        onTap: () => controller.launchLiDARScanner("Trench"),
      ),
      MeasurementItem(
        label: "Perimeter",
        icon: Icons.polyline_outlined,
        onTap: () => controller.launchLiDARScanner("Perimeter"),
      ),
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top App Bar Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.handyman_rounded,
                      color: PerfektTheme.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "PERFEKTWERK OS",
                      style: PerfektTheme.fontBold(
                        15,
                        color: PerfektTheme.primaryBlue,
                      ).copyWith(letterSpacing: 0.5),
                    ),
                  ],
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: PerfektTheme.surfaceGrey,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: PerfektTheme.borderLight,
                      width: 1,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://ui-avatars.com/api/?name=User&background=155DFC&color=fff',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Request Material Card
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.createMaterialRequest),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: PerfektTheme.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: PerfektTheme.primaryBlue.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.assignment_turned_in_outlined,
                              size: 24,
                              color: PerfektTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              "Request Material",
                              style: PerfektTheme.fontSemiBold(
                                16,
                                color: PerfektTheme.textDark,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: PerfektTheme.textLight,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    "What are you measuring?",
                    style: PerfektTheme.fontBold(
                      22,
                      color: PerfektTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Select an area to start.",
                    style: PerfektTheme.fontRegular(
                      15,
                      color: PerfektTheme.textMedium,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dynamic Grid of Measurement Types
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                    itemCount: measurementItems.length,
                    itemBuilder: (context, index) {
                      final item = measurementItems[index];
                      return _buildGridItem(item);
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(MeasurementItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: PerfektTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 32, color: PerfektTheme.primaryBlue),
            const SizedBox(height: 12),
            Text(
              item.label,
              style: PerfektTheme.fontSemiBold(
                15,
                color: PerfektTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
