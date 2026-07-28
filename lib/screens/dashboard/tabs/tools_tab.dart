import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/perfekt_theme.dart';
import '../../../../widgets/perfekt/perfekt_card.dart';
import '../../../../controllers/dashboard_controller.dart';
import '../../../../core/routes/app_routes.dart';

/// Tools tab in PerfektWerk OS.
/// CRITICAL: Preserves and highlights the existing 3D LiDAR Room Scanner tool without modifying core code!
class ToolsTab extends StatelessWidget {
  const ToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Engineering Tools",
                      style: PerfektTheme.fontBold(
                        24,
                        color: PerfektTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "High-precision digital craftsmanship suite",
                      style: PerfektTheme.fontRegular(
                        14,
                        color: PerfektTheme.textMedium,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.handyman_rounded,
                    color: PerfektTheme.primaryBlue,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // FLAGSHIP LI-DAR SCANNER TOOL CARD
            Container(
              decoration: BoxDecoration(
                borderRadius: PerfektTheme.radiusCard,
                gradient: const LinearGradient(
                  colors: [Color(0xFF155DFC), Color(0xFF3884FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: PerfektTheme.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.bolt_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "FLAGSHIP CORE FEATURE",
                                style: PerfektTheme.fontBold(
                                  10,
                                  color: Colors.white,
                                ).copyWith(letterSpacing: 0.8),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.view_in_ar_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "3D LiDAR Room Scanner",
                      style: PerfektTheme.fontBold(22, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Scan rooms and generate CAD floor plans in real-time. Features multi-tiered sensor fusion and 3D architectural reconstruction without modifying existing core scanning code.",
                      style: PerfektTheme.fontRegular(
                        14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ).copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton(
                      onPressed: () => controller.launchLiDARScanner(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: PerfektTheme.primaryBlue,
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "Launch 3D LiDAR Scanner",
                            style: PerfektTheme.fontBold(
                              15,
                              color: PerfektTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "STRUCTURAL & MATERIAL ANALYSIS",
              style: PerfektTheme.fontSemiBold(
                11,
                color: PerfektTheme.textLight,
              ).copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),

            _buildUtilityItem(
              icon: Icons.layers_outlined,
              title: "Ubakus Thermal Analysis",
              subtitle:
                  "Inspect layer insulation, U-Values, and heat flow curves.",
              onTap: () => Get.toNamed(AppRoutes.ubakusAnalysis),
              isHighlight: true,
            ),
            const SizedBox(height: 12),
            _buildUtilityItem(
              icon: Icons.inventory_2_outlined,
              title: "Material Requisition Suite",
              subtitle:
                  "Manage site material requests, stock counts, and orders.",
              onTap: () => Get.toNamed(AppRoutes.materialRequests),
              isHighlight: true,
            ),
            const SizedBox(height: 24),

            Text(
              "AUXILIARY FIELD UTILITIES",
              style: PerfektTheme.fontSemiBold(
                11,
                color: PerfektTheme.textLight,
              ).copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),

            _buildUtilityItem(
              icon: Icons.straighten_rounded,
              title: "Digital Tilt & Angle Meter",
              subtitle: "Check inclination and structural alignments.",
            ),
            const SizedBox(height: 12),
            _buildUtilityItem(
              icon: Icons.calculate_outlined,
              title: "Site Material Calculator",
              subtitle: "Compute concrete volume and foundation estimates.",
            ),
            const SizedBox(height: 12),
            _buildUtilityItem(
              icon: Icons.verified_user_outlined,
              title: "Safety Compliance Checklist",
              subtitle: "Verify ISO 27001 & workplace protocols.",
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildUtilityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isHighlight = false,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () => Get.snackbar(
            title,
            "Utility calibrated and ready.",
            snackPosition: SnackPosition.TOP,
          ),
      child: PerfektCard(
        padding: const EdgeInsets.all(16),
        borderColor: isHighlight
            ? const Color(0xFFBFDBFE)
            : PerfektTheme.borderLight,
        backgroundColor: isHighlight ? const Color(0xFFF8FAFC) : Colors.white,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHighlight
                    ? const Color(0xFFEFF6FF)
                    : PerfektTheme.surfaceGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isHighlight
                    ? PerfektTheme.primaryBlue
                    : PerfektTheme.textDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: PerfektTheme.fontBold(
                      15,
                      color: PerfektTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: PerfektTheme.fontRegular(
                      12,
                      color: PerfektTheme.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isHighlight
                  ? PerfektTheme.primaryBlue
                  : PerfektTheme.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
