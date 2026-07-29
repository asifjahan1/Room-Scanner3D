import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/perfekt_theme.dart';
import '../core/routes/app_routes.dart';

class MeasurementEntryScreen extends StatelessWidget {
  const MeasurementEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final taskName = args?['task'] as String? ?? 'Kitchen Wall';

    return Scaffold(
      backgroundColor: PerfektTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: PerfektTheme.primaryBlue),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Measurement',
          style: PerfektTheme.fontBold(18, color: PerfektTheme.primaryBlue),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              // Select Task Dropdown (Mock)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: PerfektTheme.borderLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.assignment_outlined, color: PerfektTheme.primaryBlue, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select Task',
                        style: PerfektTheme.fontMedium(15, color: PerfektTheme.textDark),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: PerfektTheme.textMedium),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Target Place Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: PerfektTheme.cardShadow,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Target Place Input
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TARGET PLACE',
                              style: PerfektTheme.fontSemiBold(12, color: PerfektTheme.primaryBlue).copyWith(letterSpacing: 1.0),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: PerfektTheme.inputBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: PerfektTheme.borderLight),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      taskName,
                                      style: PerfektTheme.fontMedium(15, color: PerfektTheme.textDark),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Measure Icon Circle
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: PerfektTheme.borderLight, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: PerfektTheme.primaryBlue.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.straighten,
                            color: PerfektTheme.primaryBlue,
                            size: 32,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Tap to measure',
                        style: PerfektTheme.fontBold(20, color: PerfektTheme.textDark),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Automatic detection active',
                        style: PerfektTheme.fontRegular(14, color: PerfektTheme.textMedium),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.memory, size: 12, color: PerfektTheme.textLight),
                          const SizedBox(width: 4),
                          Text(
                            'PERFEKTWERK V3 PRECISION SYSTEM',
                            style: PerfektTheme.fontSemiBold(10, color: PerfektTheme.textLight).copyWith(letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Bottom Measure Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.laserSync, arguments: {'task': taskName});
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
                      const Icon(Icons.straighten, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Measure',
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
    );
  }
}
