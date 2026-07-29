import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/perfekt_theme.dart';
import '../core/routes/app_routes.dart';

class LaserSyncScreen extends StatefulWidget {
  const LaserSyncScreen({super.key});

  @override
  State<LaserSyncScreen> createState() => _LaserSyncScreenState();
}

class _LaserSyncScreenState extends State<LaserSyncScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _simulationTimer;
  late String taskName;

  @override
  void initState() {
    super.initState();
    
    // Setup pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Simulate 3 second delay then navigate to Scan Area
    _simulationTimer = Timer(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.scanArea, arguments: {'task': taskName, 'fromLaser': true});
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _simulationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    taskName = args?['task'] as String? ?? 'KITCHEN WALL';
    final displayTaskName = taskName.toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.handyman, color: PerfektTheme.primaryBlue),
          onPressed: () {}, // Decorative or goes to tools
        ),
        title: Text(
          'MEASURE',
          style: PerfektTheme.fontBold(16, color: PerfektTheme.primaryBlue).copyWith(letterSpacing: 1.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: PerfektTheme.textMedium),
            onPressed: () {
              _simulationTimer?.cancel();
              Get.back();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              
              // Target Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: PerfektTheme.primaryBlue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.architecture, color: PerfektTheme.primaryBlue, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'TARGET: $displayTaskName',
                      style: PerfektTheme.fontSemiBold(12, color: PerfektTheme.primaryBlue).copyWith(letterSpacing: 1.0),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Pulsing Radar / Sync Icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: PerfektTheme.successGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: PerfektTheme.successGreen.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: PerfektTheme.successGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.straighten, // Ruler/laser icon
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 48),
              
              Text(
                'Ready to measure',
                style: PerfektTheme.fontBold(24, color: PerfektTheme.textDark),
              ),
              const SizedBox(height: 8),
              Text(
                'Press the button on your\nlaser.',
                textAlign: TextAlign.center,
                style: PerfektTheme.fontRegular(16, color: PerfektTheme.textMedium).copyWith(height: 1.5),
              ),
              
              const Spacer(),
              
              // Pro Tip Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PerfektTheme.borderLight),
                  boxShadow: PerfektTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: PerfektTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
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
                            'PRO TIP',
                            style: PerfektTheme.fontBold(12, color: PerfektTheme.textDark).copyWith(letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Keep the laser steady for\nmaximum precision.',
                            style: PerfektTheme.fontRegular(13, color: PerfektTheme.textMedium),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Cancel Button
              TextButton(
                onPressed: () {
                  _simulationTimer?.cancel();
                  Get.back();
                },
                child: Text(
                  'CANCEL SESSION',
                  style: PerfektTheme.fontSemiBold(14, color: PerfektTheme.textMedium).copyWith(letterSpacing: 1.0),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
