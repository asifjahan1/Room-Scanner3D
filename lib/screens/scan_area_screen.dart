import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/perfekt_theme.dart';
import '../core/routes/app_routes.dart';

class ScanAreaScreen extends StatelessWidget {
  const ScanAreaScreen({super.key});

  Future<void> _startScanFlow(String? taskName, bool fromLaser) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      Get.toNamed(AppRoutes.scanning, arguments: {'task': taskName, 'fromLaser': fromLaser});
    } else if (status.isPermanentlyDenied) {
      Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text(
            'Camera Permission Required',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Room scanning requires camera access to detect walls and surfaces. Please enable camera permission in Settings.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PerfektTheme.primaryBlue,
              ),
              child: const Text('Open Settings', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      Get.snackbar(
        'Permission Needed',
        'Camera permission is required to scan rooms.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve task name passed from DashboardController
    final args = Get.arguments as Map<String, dynamic>?;
    final taskName = args?['task'] as String? ?? 'Kitchen Wall'; // Default fallback
    final fromLaser = args?['fromLaser'] as bool? ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: PerfektTheme.textDark, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Scan',
          style: PerfektTheme.fontBold(18, color: PerfektTheme.textDark),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // Top Icon Container
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.view_in_ar_outlined,
                        size: 64,
                        color: PerfektTheme.primaryBlue,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -12,
                    right: -12,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: PerfektTheme.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.architecture, // Represents drafting/tools
                          size: 20,
                          color: PerfektTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -16,
                    left: -16,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.view_quilt_outlined, // Represents layout/grid
                          size: 26,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Selected Area Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PerfektTheme.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: PerfektTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.insert_drive_file_outlined,
                        color: PerfektTheme.primaryBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Area',
                            style: PerfektTheme.fontRegular(13, color: PerfektTheme.textMedium),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            taskName,
                            style: PerfektTheme.fontSemiBold(16, color: PerfektTheme.textDark),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Edit',
                        style: PerfektTheme.fontSemiBold(14, color: PerfektTheme.primaryBlue),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Informational Text
              Text(
                'Auto-detects closest fixtures.\nKeep the device steady for the\nbest accuracy.',
                textAlign: TextAlign.center,
                style: PerfektTheme.fontRegular(14, color: PerfektTheme.textMedium).copyWith(
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Start Scan Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _startScanFlow(taskName, fromLaser),
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
                      const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Start scan',
                        style: PerfektTheme.fontSemiBold(16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
