import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';

class UbakusAnalysisScreen extends StatelessWidget {
  const UbakusAnalysisScreen({super.key});

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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: PerfektTheme.primaryBlue,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Ubakus Analysis',
            style: PerfektTheme.fontBold(18, color: PerfektTheme.primaryBlue),
          ),
          centerTitle: true,
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
                // Project Context Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: PerfektTheme.radiusCard,
                    boxShadow: PerfektTheme.cardShadow,
                    border: Border.all(color: PerfektTheme.borderLight),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          width: 5,
                          decoration: const BoxDecoration(
                            color: PerfektTheme.primaryBlue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PROJECT CONTEXT",
                                style: PerfektTheme.fontBold(
                                  10,
                                  color: PerfektTheme.textLight,
                                ).copyWith(letterSpacing: 1.0),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Skyline Phase 2",
                                style: PerfektTheme.fontBold(
                                  18,
                                  color: PerfektTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: PerfektTheme.textMedium,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Zone A – External Wall",
                                    style: PerfektTheme.fontMedium(
                                      13,
                                      color: PerfektTheme.textMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Construction Layers Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Construction Layers",
                      style: PerfektTheme.fontBold(
                        16,
                        color: PerfektTheme.textDark,
                      ),
                    ),
                    Text(
                      "TOTAL: 270mm",
                      style: PerfektTheme.fontBold(
                        11,
                        color: PerfektTheme.textLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Layers List
                _buildLayerItem(
                  category: "EXTERNAL",
                  categoryColor: PerfektTheme.primaryBlue,
                  material: "Brick",
                  thickness: "115",
                  accentColor: null,
                ),
                const SizedBox(height: 10),
                _buildLayerItem(
                  category: "INSULATION",
                  categoryColor: PerfektTheme.textMedium,
                  material: "Mineral Wool",
                  thickness: "140",
                  accentColor: const Color(
                    0xFFFACC15,
                  ), // Yellow indicator strip
                ),
                const SizedBox(height: 10),
                _buildLayerItem(
                  category: "INTERNAL",
                  categoryColor: PerfektTheme.textMedium,
                  material: "Plaster",
                  thickness: "15",
                  accentColor: null,
                ),
                const SizedBox(height: 16),

                // Add Layer Button
                PerfektButton(
                  label: "ADD LAYER",
                  icon: Icons.add_rounded,
                  height: 46,
                  fontSize: 14,
                  onPressed: () => Get.snackbar(
                    "Add Layer",
                    "Material catalogue dialog initialized.",
                    snackPosition: SnackPosition.TOP,
                  ),
                ),
                const SizedBox(height: 24),

                // U-Value & R-Value Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        label: "U-VALUE",
                        value: "0.24",
                        unit: "W/(m²·K)",
                        isHighlight: true,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildMetricCard(
                        label: "R-VALUE",
                        value: "4.15",
                        unit: "(m²·K)/W",
                        isHighlight: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Condensation Risk Badge Card
                _buildStatusBanner(
                  icon: Icons.check_circle_outline_rounded,
                  iconBg: const Color(0xFFD1FAE5),
                  iconColor: const Color(0xFF059669),
                  title: "CONDENSATION RISK",
                  status: "Safe / Low Risk",
                  statusColor: const Color(0xFF059669),
                ),
                const SizedBox(height: 12),

                // Moisture Status Badge Card
                _buildStatusBanner(
                  icon: Icons.water_drop_outlined,
                  iconBg: const Color(0xFFD1FAE5),
                  iconColor: const Color(0xFF059669),
                  title: "MOISTURE STATUS",
                  status: "Drying Required",
                  statusColor: const Color(0xFF059669),
                ),
                const SizedBox(height: 24),

                // Heat Flow Chart Card
                _buildChartCard(
                  title: "HEAT FLOW",
                  badge: "Laminar",
                  badgeColor: PerfektTheme.primaryBlue,
                  lineColor: PerfektTheme.primaryBlue,
                  leftLabel: "EXT",
                  rightLabel: "INT",
                  isHeatFlow: true,
                ),
                const SizedBox(height: 16),

                // Temperature Profile Chart Card
                _buildChartCard(
                  title: "TEMPERATURE PROFILE",
                  badge: "20°C / -5°C",
                  badgeColor: PerfektTheme.textDark,
                  lineColor: const Color(0xFFDC2626),
                  leftLabel: "-5°C",
                  rightLabel: "20°C",
                  isHeatFlow: false,
                ),
                const SizedBox(height: 28),

                // Run Analysis Primary Button
                PerfektButton(
                  label: "RUN ANALYSIS",
                  icon: Icons.play_arrow_rounded,
                  height: 54,
                  fontSize: 16,
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Simulation',
                      titleStyle: PerfektTheme.fontBold(18, color: PerfektTheme.textDark),
                      middleText: 'Choose the analysis outcome for testing:',
                      middleTextStyle: PerfektTheme.fontRegular(14, color: PerfektTheme.textMedium),
                      textConfirm: 'Success',
                      textCancel: 'Redo Needed',
                      confirmTextColor: Colors.white,
                      buttonColor: PerfektTheme.primaryBlue,
                      cancelTextColor: PerfektTheme.primaryBlue,
                      onConfirm: () {
                        Get.back(); // close dialog
                        Get.snackbar(
                          "Analysis Completed",
                          "Thermal bridging and condensation metrics verified.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: PerfektTheme.successGreen,
                          colorText: Colors.white,
                        );
                      },
                      onCancel: () {
                        Get.toNamed(AppRoutes.redoNeeded, arguments: {'task': 'Kitchen Wall'});
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayerItem({
    required String category,
    required Color categoryColor,
    required String material,
    required String thickness,
    Color? accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(color: PerfektTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (accentColor != null)
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: Icon(
                Icons.drag_indicator_rounded,
                color: PerfektTheme.textLight,
                size: 20,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category,
                    style: PerfektTheme.fontBold(
                      10,
                      color: categoryColor,
                    ).copyWith(letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    material,
                    style: PerfektTheme.fontBold(
                      15,
                      color: PerfektTheme.textDark,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: PerfektTheme.surfaceGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    thickness,
                    style: PerfektTheme.fontBold(
                      14,
                      color: PerfektTheme.textDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "mm",
                    style: PerfektTheme.fontRegular(
                      12,
                      color: PerfektTheme.textMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required String unit,
    required bool isHighlight,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(color: PerfektTheme.borderLight),
        boxShadow: PerfektTheme.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: PerfektTheme.fontBold(
              11,
              color: PerfektTheme.textLight,
            ).copyWith(letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: PerfektTheme.fontBold(
              32,
              color: isHighlight
                  ? PerfektTheme.primaryBlue
                  : PerfektTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: PerfektTheme.fontMedium(12, color: PerfektTheme.textMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(color: PerfektTheme.borderLight),
        boxShadow: PerfektTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: PerfektTheme.fontBold(
                    10,
                    color: PerfektTheme.textLight,
                  ).copyWith(letterSpacing: 0.8),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: PerfektTheme.fontBold(15, color: statusColor),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.info_outline_rounded,
            color: PerfektTheme.textLight,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String badge,
    required Color badgeColor,
    required Color lineColor,
    required String leftLabel,
    required String rightLabel,
    required bool isHeatFlow,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(color: PerfektTheme.borderLight),
        boxShadow: PerfektTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: PerfektTheme.fontBold(
                  11,
                  color: PerfektTheme.textLight,
                ).copyWith(letterSpacing: 0.8),
              ),
              Text(badge, style: PerfektTheme.fontBold(13, color: badgeColor)),
            ],
          ),
          const SizedBox(height: 24),
          // Graphical representation of thermal curve
          SizedBox(
            height: 70,
            width: double.infinity,
            child: CustomPaint(
              painter: _ThermalGraphPainter(
                color: lineColor,
                isHeatFlow: isHeatFlow,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftLabel,
                style: PerfektTheme.fontMedium(
                  12,
                  color: PerfektTheme.textLight,
                ),
              ),
              Text(
                rightLabel,
                style: PerfektTheme.fontMedium(
                  12,
                  color: PerfektTheme.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThermalGraphPainter extends CustomPainter {
  final Color color;
  final bool isHeatFlow;
  _ThermalGraphPainter({required this.color, required this.isHeatFlow});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    if (isHeatFlow) {
      // Gentle stepped curve upwards
      path.moveTo(0, size.height * 0.8);
      path.lineTo(size.width * 0.3, size.height * 0.65);
      path.lineTo(size.width * 0.5, size.height * 0.6);
      path.lineTo(size.width * 0.65, size.height * 0.25);
      path.lineTo(size.width, size.height * 0.15);
    } else {
      // Steep insulation temperature gradient
      path.moveTo(0, size.height * 0.85);
      path.lineTo(size.width * 0.35, size.height * 0.8);
      path.lineTo(size.width * 0.65, size.height * 0.15);
      path.lineTo(size.width, size.height * 0.1);
    }

    canvas.drawPath(path, paint);

    // Draw reference grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      gridPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
