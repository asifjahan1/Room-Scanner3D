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
                  subtitle: "10 Bags",
                  tag: "Pending Approval",
                  tagColor: PerfektTheme.primaryBlue,
                  tagBg: const Color(0xFFEFF6FF),
                  category: "Wall",
                ),
                const SizedBox(height: 14),
                _buildRequestCard(
                  title: "Timber Slats",
                  subtitle: "20 Slats",
                  tag: "Next Planning",
                  tagColor: const Color(0xFF059669),
                  tagBg: const Color(0xFFD1FAE5),
                  category: "Floor",
                ),
                const SizedBox(height: 14),
                _buildRequestCard(
                  title: "Drywall Panels",
                  subtitle: "50 Sheets",
                  tag: "Order Ready",
                  tagColor: const Color(0xFF2563EB),
                  tagBg: const Color(0xFFDBEAFE),
                  category: "Ceiling",
                ),
                const SizedBox(height: 14),
                _buildRequestCard(
                  title: "PVC Pipes",
                  subtitle: "20 Units",
                  tag: "Damage Setup",
                  tagColor: const Color(0xFF64748B),
                  tagBg: const Color(0xFFF1F5F9),
                  category: "Plumb",
                ),
                const SizedBox(height: 14),
                _buildRequestCard(
                  title: "Special Grout",
                  subtitle: "5 Units",
                  tag: "Next Planning",
                  tagColor: const Color(0xFFD97706),
                  tagBg: const Color(0xFFFEF3C7),
                  category: "Tile",
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
    required String tag,
    required Color tagColor,
    required Color tagBg,
    required String category,
  }) {
    return PerfektCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: PerfektTheme.surfaceGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
                  style: PerfektTheme.fontBold(11, color: PerfektTheme.textMedium),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: PerfektTheme.fontBold(12, color: tagColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: PerfektTheme.fontBold(18, color: PerfektTheme.textDark),
              ),
              Text(
                subtitle,
                style: PerfektTheme.fontMedium(15, color: PerfektTheme.textMedium),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
