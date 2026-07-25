import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/room_scan.dart';
import '../repositories/scan_repository.dart';
import '../services/scanner_service.dart';

/// GetX controller managing the scanning session lifecycle.
class ScanningController extends GetxController {
  final ScanRepository _scanRepo = Get.find<ScanRepository>();

  // ─── Reactive State ───
  final isScanning = false.obs;
  final isInitialized = false.obs;
  final scanProgress = 0.0.obs;
  final wallsDetected = 0.obs;
  final openingsDetected = 0.obs;
  final guidanceMessage = ''.obs;
  final trackingQuality = TrackingQuality.good.obs;
  final warnings = <String>[].obs;
  final scannedRoom = Rxn<RoomScan>();

  MethodChannel? _viewChannel;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
    isInitialized.value = true;
  }

  /// Setup platform channel for the native view.
  void setupPlatformChannel(int viewId) {
    final channelName = Platform.isIOS
        ? 'com.app.liddar/roomplan_view_$viewId'
        : 'com.app.liddar/arcore_view_$viewId';

    _viewChannel = MethodChannel(channelName);
    _viewChannel?.setMethodCallHandler(_handleNativeCall);

    startScanning();
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'onScanProgress':
        final data = Map<String, dynamic>.from(call.arguments as Map);
        wallsDetected.value =
            (data['wallsDetected'] as num?)?.toInt() ?? wallsDetected.value;
        openingsDetected.value =
            (data['openingsDetected'] as num?)?.toInt() ?? openingsDetected.value;
        scanProgress.value =
            (data['percentage'] as num?)?.toDouble() ?? scanProgress.value;
        final msg = data['message'] as String?;
        if (msg != null && msg.isNotEmpty) {
          guidanceMessage.value = msg;
        }
        break;

      case 'onScanComplete':
        final data = Map<String, dynamic>.from(call.arguments as Map);
        scannedRoom.value = ScannerService.parseScanResult(data);
        Get.offNamed('/scan-complete', arguments: scannedRoom.value);
        break;

      case 'onScanError':
        final error = call.arguments is Map
            ? call.arguments['error']
            : call.arguments.toString();
        isScanning.value = false;
        Get.snackbar('AR Error', 'Failed to start AR: $error',
            snackPosition: SnackPosition.BOTTOM);
        break;

      case 'onInstruction':
        final msg = call.arguments is Map
            ? call.arguments['message'] as String?
            : null;
        if (msg != null) guidanceMessage.value = msg;
        break;

      case 'onTrackingState':
        final state = call.arguments as String?;
        if (state == 'limited') {
          trackingQuality.value = TrackingQuality.limited;
        } else if (state == 'lost') {
          trackingQuality.value = TrackingQuality.lost;
        } else {
          trackingQuality.value = TrackingQuality.good;
        }
        break;

      case 'onWarning':
        final warning = call.arguments as String?;
        if (warning != null) {
          warnings.add(warning);
          Future.delayed(const Duration(seconds: 3), () {
            warnings.remove(warning);
          });
        }
        break;
    }
  }

  /// Start scanning session.
  Future<void> startScanning() async {
    isScanning.value = true;
    _scanRepo.startNewScan(const Uuid().v4());

    try {
      if (_viewChannel != null) {
        await _viewChannel?.invokeMethod('startScan');
      } else {
        await ScannerService.startScan();
      }
    } catch (e) {
      Get.log('Error starting native scan: $e');
    }
  }

  /// Capture a wall manually.
  Future<void> captureWall() async {
    try {
      if (_viewChannel != null) {
        await _viewChannel?.invokeMethod('captureWall');
      }
    } catch (e) {
      Get.log('Error capturing wall: $e');
    }
  }

  /// Stop scanning and get results.
  Future<RoomScan?> stopScanning() async {
    isScanning.value = false;

    try {
      if (_viewChannel != null) {
        final result = await _viewChannel
            ?.invokeMethod<Map<dynamic, dynamic>>('stopScan');
        if (result != null) {
          scannedRoom.value = ScannerService.parseScanResult(
              Map<String, dynamic>.from(result));
        }
      } else {
        final result = await ScannerService.stopScan();
        if (result != null) {
          scannedRoom.value = ScannerService.parseScanResult(result);
        }
      }
    } catch (e) {
      Get.log('Error stopping native scan: $e');
    }

    return scannedRoom.value;
  }

  /// Cancel scanning without saving.
  Future<void> cancelScanning() async {
    isScanning.value = false;
    _scanRepo.cancelScan();

    try {
      if (_viewChannel != null) {
        await _viewChannel?.invokeMethod('cancelScan');
      } else {
        await ScannerService.cancelScan();
      }
    } catch (e) {
      Get.log('Error cancelling scan: $e');
    }
  }

  @override
  void onClose() {
    isScanning.value = false;
    super.onClose();
  }
}
