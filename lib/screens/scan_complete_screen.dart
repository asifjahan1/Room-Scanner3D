import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/perfekt_theme.dart';
import '../models/room_scan.dart';
import '../core/routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';

class ScanCompleteScreen extends StatelessWidget {
  final RoomScan? roomScan;

  const ScanCompleteScreen({super.key, this.roomScan});

  @override
  Widget build(BuildContext context) {
    RoomScan? scan = roomScan;
    String areaName = 'Unknown Area';

    if (scan != null) {
      areaName = scan.label ?? 'Unknown Area';
    } else if (Get.arguments != null) {
      if (Get.arguments is RoomScan) {
        scan = Get.arguments as RoomScan;
        areaName = scan.label ?? 'Unknown Area';
      } else if (Get.arguments is Map) {
        final args = Get.arguments as Map;
        areaName = args['task'] as String? ?? 'Unknown Area';
      }
    }

    return Scaffold(
      backgroundColor: PerfektTheme.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success Card
              Container(
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
                  children: [
                    // Green Checkmark
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: PerfektTheme.successGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle,
                          color: PerfektTheme.successGreen,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Scan sent for review',
                      style: PerfektTheme.fontBold(20, color: PerfektTheme.textDark),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Area: $areaName',
                      style: PerfektTheme.fontRegular(14, color: PerfektTheme.textMedium),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Buttons
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Explicitly switch to Tools tab (index 2) before popping back
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
                      const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'BACK TO CAPTURE',
                        style: PerfektTheme.fontSemiBold(14, color: Colors.white).copyWith(letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    // Scan another area -> Go back to ScanAreaScreen for the same task
                    Get.offNamedUntil(
                      AppRoutes.scanArea, 
                      (route) => route.settings.name == AppRoutes.dashboard, 
                      arguments: {'task': areaName}
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: PerfektTheme.borderLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, color: PerfektTheme.primaryBlue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'SCAN ANOTHER AREA',
                        style: PerfektTheme.fontSemiBold(14, color: PerfektTheme.primaryBlue).copyWith(letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
