import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';

class MaterialRequestsScreen extends StatelessWidget {
  const MaterialRequestsScreen({super.key});

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
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: PerfektTheme.primaryBlue, size: 20),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'MATERIAL REQUESTS',
            style: PerfektTheme.fontBold(16, color: PerfektTheme.primaryBlue).copyWith(
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14.0),
            child: Column(
              children: [
                // Create Request Primary Button
                PerfektButton(
                  label: "Create request",
                  icon: Icons.add_rounded,
                  height: 52,
                  fontSize: 15,
                  onPressed: () => Get.toNamed(AppRoutes.createMaterialRequest),
                ),
                const SizedBox(height: 24),

                // Material Request Items List
                _buildRequestCard(
                  title: "Cement Bags",
                  subtitle: "10 Units",
                  task: "Foundation Pour",
                  statusText: "SENT",
                  statusColor: PerfektTheme.primaryBlue,
                  statusBg: const Color(0xFFEFF6FF),
                ),
                const SizedBox(height: 14),
                _buildRequestCard(
                  title: "Timber Joists",
                  subtitle: "24 Units",
                  task: "Roof Framing",
                  statusText: "APPROVED",
                  statusColor: const Color(0xFF059669),
                  statusBg: const Color(0xFFD1FAE5),
                ),
                const SizedBox(height: 14),
                _buildRequestCard(
                  title: "Drywall Panels",
                  subtitle: "50 Units",
                  task: "Interior Walls",
                  statusText: "ON THE WAY",
                  statusColor: PerfektTheme.primaryBlue,
                  statusBg: const Color(0xFFEFF6FF),
                  hasProgressBar: true,
                  leftBorderColor: PerfektTheme.primaryBlue,
                  borderColor: PerfektTheme.primaryBlue,
                ),
                const SizedBox(height: 14),
                _buildRequestCard(
                  title: "PVC Pipes",
                  subtitle: "5 Units",
                  task: "Drainage Setup",
                  statusText: "DELIVERED",
                  statusColor: const Color(0xFF64748B),
                  statusBg: const Color(0xFFF1F5F9),
                ),
                const SizedBox(height: 14),
                _buildRequestCard(
                  title: "Special Grout",
                  subtitle: "2 Units",
                  task: "Tile Finishing",
                  statusText: "NEEDS CLARIFICATION",
                  statusColor: const Color(0xFFDC2626),
                  statusBg: const Color(0xFFFEF2F2),
                  hasInfoIcon: true,
                  borderColor: const Color(0xFFFECACA),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard({
    required String title,
    required String subtitle,
    required String task,
    required String statusText,
    required Color statusColor,
    required Color statusBg,
    bool hasProgressBar = false,
    bool hasInfoIcon = false,
    Color? borderColor,
    Color? leftBorderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(color: borderColor ?? PerfektTheme.borderLight, width: 1.5),
        boxShadow: PerfektTheme.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: PerfektTheme.radiusCard,
        child: Container(
          decoration: BoxDecoration(
            border: leftBorderColor != null
                ? Border(left: BorderSide(color: leftBorderColor, width: 4))
                : null,
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tag Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      statusText.toUpperCase(),
                      style: PerfektTheme.fontBold(10, color: statusColor).copyWith(letterSpacing: 0.5),
                    ),
                    if (hasInfoIcon) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.info_outline_rounded, size: 14, color: statusColor),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                title,
                style: PerfektTheme.fontSemiBold(16, color: PerfektTheme.textDark),
              ),
              const SizedBox(height: 18),
              
              // Quantity & Task Columns
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "QUANTITY",
                          style: PerfektTheme.fontBold(9, color: PerfektTheme.textLight).copyWith(letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: PerfektTheme.fontBold(14, color: PerfektTheme.textDark),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TASK",
                          style: PerfektTheme.fontBold(9, color: PerfektTheme.textLight).copyWith(letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task,
                          style: PerfektTheme.fontRegular(14, color: PerfektTheme.textDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              if (hasProgressBar) ...[
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: PerfektTheme.primaryBlue,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          color: PerfektTheme.surfaceGrey,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
