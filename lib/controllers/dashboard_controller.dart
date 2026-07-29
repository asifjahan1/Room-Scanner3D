import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
import '../core/routes/app_routes.dart';

/// Dashboard and shift session controller for PerfektWerk OS.
/// Safely interfaces with existing LiDAR scanning features without altering core scanner logic.
class DashboardController extends GetxController {
  // Navigation Bar Active Tab (0: Home, 1: Tasks, 2: Tools, 3: Messages, 4: More)
  final selectedTab = 0.obs;

  // Shift Timer States
  final isClockedIn = false.obs;
  final isOnBreak = false.obs;
  final shiftSeconds = 0.obs;
  final lastShiftSummary = "8h 15m".obs;

  Timer? _timer;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// Change selected tab in bottom navigation bar
  void changeTab(int index) {
    selectedTab.value = index;
  }

  /// Formatted timer text HH:MM:SS
  String get formattedTimer {
    final hours = (shiftSeconds.value ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((shiftSeconds.value % 3600) ~/ 60).toString().padLeft(
      2,
      '0',
    );
    final seconds = (shiftSeconds.value % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Toggle Clock In / Clock Out
  void toggleClockIn() {
    if (!isClockedIn.value) {
      // Clocking in: start timer
      isClockedIn.value = true;
      isOnBreak.value = false;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!isOnBreak.value) {
          shiftSeconds.value++;
        }
      });
      Get.snackbar(
        'Clocked In',
        'Shift session started at Berlin Sector C-4.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF16A34A),
        colorText: Colors.white,
      );
    } else {
      // Clocking out: stop timer and show Shift Ended screen
      _timer?.cancel();
      _timer = null;
      isClockedIn.value = false;
      isOnBreak.value = false;

      // Calculate summary if timer ran, or default to 8h 15m as per mockup
      if (shiftSeconds.value > 60) {
        final h = shiftSeconds.value ~/ 3600;
        final m = (shiftSeconds.value % 3600) ~/ 60;
        lastShiftSummary.value = "${h > 0 ? '$h h ' : ''}${m}m";
      } else {
        lastShiftSummary.value = "8h 15m";
      }

      shiftSeconds.value = 0;
      Get.toNamed(AppRoutes.shiftEnded);
    }
  }

  /// Toggle Break mode during shift
  void toggleBreak() {
    if (!isClockedIn.value) {
      Get.snackbar(
        'Not Clocked In',
        'Please clock in before initiating a break.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF334155),
        colorText: Colors.white,
      );
      return;
    }
    isOnBreak.value = !isOnBreak.value;
    Get.snackbar(
      isOnBreak.value ? 'Break Started' : 'Break Ended',
      isOnBreak.value
          ? 'Timer suspended during break.'
          : 'Timer resumed for shift.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: isOnBreak.value
          ? const Color(0xFFF97316)
          : const Color(0xFF16A34A),
      colorText: Colors.white,
    );
  }

  /// View My Day action (navigates to My Day timeline PLANS screen)
  void viewMyDay() {
    Get.toNamed(AppRoutes.myDayTimeline);
  }

  /// Trigger daily site progress update & sync confirmation
  void triggerDailyUpdate() {
    Get.toNamed(AppRoutes.syncComplete);
  }

  /// Navigate to Weather details screen
  void openWeatherScreen() {
    Get.toNamed(AppRoutes.weather);
  }

  /// Return to Home tab from Shift Ended screen
  void backToHomeFromShift() {
    selectedTab.value = 0;
    Get.offNamedUntil(AppRoutes.dashboard, (route) => false);
  }

  /// View My Day from Shift Ended screen
  void viewMyDayFromShift() {
    selectedTab.value = 1;
    Get.offNamedUntil(AppRoutes.dashboard, (route) => false);
  }

  /// CRITICAL REQUIREMENT: Access existing 3D LiDAR Room Scanner feature
  /// WITHOUT changing or disrupting existing core scanning code.
  Future<void> launchLiDARScanner([String? taskName]) async {
    if (taskName != null && taskName.toLowerCase() == 'room') {
      // Navigate to the Scan Area screen (LiDAR flow)
      Get.toNamed(AppRoutes.scanArea, arguments: {'task': taskName});
    } else {
      // Navigate to Measurement Entry screen (Laser flow)
      Get.toNamed(AppRoutes.measurementEntry, arguments: taskName != null ? {'task': taskName} : null);
    }
  }
}
