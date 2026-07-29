import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/dashboard_controller.dart';

class RedoNeededScreen extends StatelessWidget {
  const RedoNeededScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final taskName = args?['task'] as String? ?? 'Kitchen Wall';

    return Scaffold(
      backgroundColor: PerfektTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: PerfektTheme.primaryBlue,
            size: 24,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Redo Needed',
          style: PerfektTheme.fontBold(20, color: PerfektTheme.primaryBlue),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Alert Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCA5A5).withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFF991B1B), // Dark red
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'Please measure again',
                  style: PerfektTheme.fontBold(22, color: PerfektTheme.textDark),
                ),
                const SizedBox(height: 12),
                
                // Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: PerfektTheme.surfaceGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    taskName,
                    style: PerfektTheme.fontSemiBold(14, color: PerfektTheme.textMedium),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Image Placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&q=80&w=600&h=400',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: PerfektTheme.surfaceGrey,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: PerfektTheme.textMedium,
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                
                // Foreman's Note Box
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: PerfektTheme.primaryBlue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: PerfektTheme.primaryBlue,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "FOREMAN'S NOTE",
                            style: PerfektTheme.fontBold(12, color: PerfektTheme.primaryBlue).copyWith(
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "The last measurement seems a bit short for this section. Please double-check the laser placement.",
                        style: PerfektTheme.fontRegular(14, color: PerfektTheme.textDark).copyWith(
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Measure Again Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to the tools tab (Dashboard)
                      if (Get.isRegistered<DashboardController>()) {
                        Get.find<DashboardController>().changeTab(2);
                      }
                      Get.until((route) => Get.currentRoute == AppRoutes.dashboard);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PerfektTheme.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.straighten_outlined, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Measure again',
                          style: PerfektTheme.fontSemiBold(16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
