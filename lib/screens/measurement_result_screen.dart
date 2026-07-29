import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/perfekt_theme.dart';
import '../core/routes/app_routes.dart';

class MeasurementResultScreen extends StatefulWidget {
  const MeasurementResultScreen({super.key});

  @override
  State<MeasurementResultScreen> createState() => _MeasurementResultScreenState();
}

class _MeasurementResultScreenState extends State<MeasurementResultScreen> {
  bool _hasPhoto = false;

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final taskName = args?['task'] as String? ?? 'Kitchen Wall';

    return Scaffold(
      backgroundColor: PerfektTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.handyman, color: PerfektTheme.primaryBlue),
        title: Text(
          'PERFEKTWERK OS',
          style: PerfektTheme.fontBold(16, color: PerfektTheme.primaryBlue).copyWith(letterSpacing: 0.5),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: PerfektTheme.primaryBlueLight,
              child: const Icon(Icons.person, color: PerfektTheme.primaryBlue, size: 20),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Verified badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: PerfektTheme.successGreen, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'VERIFIED MEASUREMENT',
                    style: PerfektTheme.fontSemiBold(12, color: PerfektTheme.textMedium).copyWith(letterSpacing: 1.0),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Measurement Result Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: PerfektTheme.cardShadow,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'LINEAR DISTANCE',
                          style: PerfektTheme.fontSemiBold(12, color: PerfektTheme.textMedium).copyWith(letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '4.28 m',
                          style: PerfektTheme.fontBold(48, color: PerfektTheme.primaryBlue),
                        ),
                        const SizedBox(height: 24),
                        // Add Photo Pill
                        InkWell(
                          onTap: () {
                            setState(() {
                              _hasPhoto = true;
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _hasPhoto ? PerfektTheme.successGreenBg : PerfektTheme.inputBackground,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _hasPhoto ? PerfektTheme.successGreen : PerfektTheme.borderLight),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _hasPhoto ? Icons.check : Icons.add_a_photo_outlined, 
                                  size: 16, 
                                  color: _hasPhoto ? PerfektTheme.successGreen : PerfektTheme.textMedium,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _hasPhoto ? 'Photo Added' : 'Add Photo',
                                  style: PerfektTheme.fontMedium(14, color: _hasPhoto ? PerfektTheme.successGreen : PerfektTheme.textMedium),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(Icons.edit, color: PerfektTheme.primaryBlue, size: 20),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Use UBAKUS Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.ubakusAnalysis);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PerfektTheme.primaryBlueDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Use UBAKUS',
                        style: PerfektTheme.fontSemiBold(16, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Save and Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offNamed(AppRoutes.scanComplete, arguments: {'task': taskName});
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
                      const Icon(Icons.save_outlined, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Save and Submit',
                        style: PerfektTheme.fontSemiBold(16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Measure Again Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Get.offNamedUntil(
                      AppRoutes.scanArea, 
                      (route) => route.settings.name == AppRoutes.dashboard,
                      arguments: {'task': taskName, 'fromLaser': true}
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
                      const Icon(Icons.refresh, color: PerfektTheme.primaryBlue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Measure again',
                        style: PerfektTheme.fontSemiBold(16, color: PerfektTheme.primaryBlue),
                      ),
                    ],
                  ),
                ),
              ),
              
              if (_hasPhoto) ...[
                const SizedBox(height: 32),
                
                // Site Image Placeholder
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: PerfektTheme.surfaceDarkGrey,
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1541888086913-dfea681283d6?q=80&w=600&auto=format&fit=crop'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                        ),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'SECTOR A-4 // COLUMN 12',
                            style: PerfektTheme.fontSemiBold(10, color: Colors.white).copyWith(letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
