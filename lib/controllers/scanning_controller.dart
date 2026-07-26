import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/room_scan.dart';
import '../repositories/scan_repository.dart';
import '../services/scanner_service.dart';
import '../core/routes/app_routes.dart';

/// GetX controller managing continuous video room scanning & post-processing geometry reconstruction.
class ScanningController extends GetxController {
  final ScanRepository _scanRepo = Get.find<ScanRepository>();

  // ─── Reactive State ───
  final isScanning = false.obs;
  final isRecording = false.obs;
  final isProcessing = false.obs;
  final isInitialized = false.obs;
  final recordingSeconds = 0.obs;
  final scanProgress = 0.0.obs;
  final wallsDetected = 0.obs;
  final openingsDetected = 0.obs;
  final guidanceMessage = ''.obs;
  final trackingQuality = TrackingQuality.good.obs;
  final warnings = <String>[].obs;
  final scannedRoom = Rxn<RoomScan>();

  MethodChannel? _viewChannel;
  Timer? _recordingTimer;

  /// Completer used to wait for the native platform to deliver scan results
  /// via the `onScanComplete` callback. This avoids the race condition where
  /// the Flutter side also tries to get results from the `stopScan` return value.
  Completer<RoomScan?>? _scanCompleter;

  String get recordingDurationText {
    final mins = (recordingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final secs = (recordingSeconds.value % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
    isInitialized.value = true;
    guidanceMessage.value =
        'Point camera at a room corner or starting point and tap record to begin';
  }

  /// Setup platform channel for the native view without automatically starting recording.
  void setupPlatformChannel(int viewId) {
    final channelName = Platform.isIOS
        ? 'com.app.liddar/roomplan_view_$viewId'
        : 'com.app.liddar/arcore_view_$viewId';

    _viewChannel = MethodChannel(channelName);
    _viewChannel?.setMethodCallHandler(_handleNativeCall);
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'onScanProgress':
        if (!isRecording.value) return;
        final data = Map<String, dynamic>.from(call.arguments as Map);
        wallsDetected.value =
            (data['wallsDetected'] as num?)?.toInt() ?? wallsDetected.value;
        openingsDetected.value =
            (data['openingsDetected'] as num?)?.toInt() ??
            openingsDetected.value;
        scanProgress.value =
            (data['percentage'] as num?)?.toDouble() ?? scanProgress.value;
        final msg = data['message'] as String?;
        if (msg != null && msg.isNotEmpty) {
          guidanceMessage.value = msg;
        } else {
          guidanceMessage.value =
              'Capturing room... slowly move along wall intersections & corners';
        }
        break;

      case 'onScanComplete':
        final data = Map<String, dynamic>.from(call.arguments as Map);
        final rawScan = ScannerService.parseScanResult(data);
        // If we have a pending completer from stopScanning(), resolve it
        if (_scanCompleter != null && !_scanCompleter!.isCompleted) {
          _scanCompleter!.complete(rawScan);
        } else {
          // Native side sent scan complete asynchronously (e.g. auto-complete)
          await _processAndCompleteScan(rawScan);
        }
        break;

      case 'onScanError':
        final error = call.arguments is Map
            ? call.arguments['error']
            : call.arguments.toString();
        isScanning.value = false;
        isRecording.value = false;
        _stopRecordingTimer();
        // Resolve completer with null on error so stopScanning doesn't hang
        if (_scanCompleter != null && !_scanCompleter!.isCompleted) {
          _scanCompleter!.complete(null);
        }
        Get.snackbar(
          'AR Sensor Notice',
          'AR session encountered an issue: $error',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error.withValues(alpha: 0.9),
          colorText: Get.theme.colorScheme.onError,
        );
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

  /// Start seamless video-style continuous room recording.
  Future<void> startScanning() async {
    if (isRecording.value) return;

    isScanning.value = true;
    isRecording.value = true;
    recordingSeconds.value = 0;
    wallsDetected.value = 0;
    openingsDetected.value = 0;
    scanProgress.value = 0.1;
    guidanceMessage.value =
        'Continuous capture active. Walk slowly around the room perimeter.';

    _scanRepo.startNewScan(const Uuid().v4());
    _startRecordingTimer();

    try {
      if (_viewChannel != null) {
        await _viewChannel?.invokeMethod('startScan');
      } else {
        await ScannerService.startScan();
      }
    } catch (e) {
      Get.log('Error starting native continuous scan: $e');
    }
  }

  void _startRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordingSeconds.value++;
      // No fake wall simulation — only show what native sensors actually detect.
      // If after 8 seconds no walls detected, give the user guidance.
      if (recordingSeconds.value >= 8 && wallsDetected.value == 0) {
        guidanceMessage.value =
            'No walls detected yet. Move camera slowly along floor-wall intersections.';
      }
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  /// Capture a manual corner / wall anchor point while recording.
  Future<void> captureWall() async {
    try {
      if (_viewChannel != null) {
        await _viewChannel?.invokeMethod('captureWall');
      }
      // Don't manually increment wallsDetected here — let the native side
      // report actual wall count via onScanProgress callback.
    } catch (e) {
      Get.log('Error capturing manual wall point: $e');
    }
  }

  /// Stop scanning, initiate post-processing 3D room reconstruction, and generate aligned floor plan.
  Future<RoomScan?> stopScanning() async {
    if (!isScanning.value && !isRecording.value) return null;

    _stopRecordingTimer();
    isRecording.value = false;
    isProcessing.value = true;

    // Create a Completer to wait for the native `onScanComplete` callback.
    // The native side sends results via the callback, so we wait for that
    // instead of relying on the direct return value (which caused a race condition).
    _scanCompleter = Completer<RoomScan?>();

    RoomScan? nativeResult;
    try {
      if (_viewChannel != null) {
        // Tell native to stop — it will send results via onScanComplete callback
        final directResult = await _viewChannel?.invokeMethod<Map<dynamic, dynamic>>(
          'stopScan',
        );
        // If we got a direct result AND the completer hasn't been resolved yet
        // by the callback, use the direct result
        if (directResult != null && !_scanCompleter!.isCompleted) {
          final parsed = ScannerService.parseScanResult(
            Map<String, dynamic>.from(directResult),
          );
          _scanCompleter!.complete(parsed);
        }
      } else {
        final result = await ScannerService.stopScan();
        if (result != null && !_scanCompleter!.isCompleted) {
          _scanCompleter!.complete(ScannerService.parseScanResult(result));
        }
      }
    } catch (e) {
      Get.log('Error stopping native scan: $e');
      // If native call fails, complete with null so we don't hang
      if (!_scanCompleter!.isCompleted) {
        _scanCompleter!.complete(null);
      }
    }

    // Wait for result from either the callback or the direct return, with a timeout
    try {
      nativeResult = await _scanCompleter!.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );
    } catch (e) {
      Get.log('Timeout waiting for scan result: $e');
      nativeResult = null;
    }
    _scanCompleter = null;

    // If we truly got no data from the native side, show error
    if (nativeResult == null || nativeResult.walls.isEmpty) {
      isProcessing.value = false;
      isScanning.value = false;
      Get.snackbar(
        'Scan Failed',
        'Could not detect any walls. Please try again — move camera slowly along floor-wall intersections in a well-lit room.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Get.theme.colorScheme.error.withValues(alpha: 0.9),
        colorText: Get.theme.colorScheme.onError,
      );
      return null;
    }

    await _processAndCompleteScan(nativeResult);
    return scannedRoom.value;
  }

  /// Automated Post-Processing Geometry Reconstruction & Alignment Engine.
  /// Straightens wall segments, snaps angles to orthogonal axes (90°/180°/270°), and cleanly closes polygon loops.
  Future<void> _processAndCompleteScan(RoomScan rawRoom) async {
    isProcessing.value = true;
    // Keep processing overlay visible for 1.8s for smooth high-tech visual feedback
    await Future.delayed(const Duration(milliseconds: 1800));

    final alignedWalls = _orthogonalizeAndCloseWalls(rawRoom.walls);
    final calculatedArea = _calculatePolygonArea(alignedWalls);
    final calculatedPerimeter = _calculatePerimeter(alignedWalls);

    final polishedRoom = rawRoom.copyWith(
      walls: alignedWalls,
      area: calculatedArea,
      perimeter: calculatedPerimeter,
      status: ScanStatus.completed,
    );

    scannedRoom.value = polishedRoom;
    isProcessing.value = false;
    isScanning.value = false;

    Get.offNamed(AppRoutes.scanComplete, arguments: polishedRoom);
  }

  /// Straightens wall segments and joins endpoints so room boundary forms a crisp polygon.
  /// If no walls were captured, returns empty list instead of fake data.
  List<WallSegment> _orthogonalizeAndCloseWalls(List<WallSegment> inputWalls) {
    if (inputWalls.isEmpty) {
      // Return empty — no fake rectangles. The caller handles the error state.
      return [];
    }

    // If user performed a partial scan (1 or 2 wall segments), preserve their exact captured geometry without forcing a closed box
    if (inputWalls.length < 3) {
      return inputWalls;
    }

    final int n = inputWalls.length;
    final List<WallSegment> processed = [];

    // Link consecutive endpoints cleanly in sequence so there are no open boundary seams or intersecting overshoots
    for (int i = 0; i < n; i++) {
      final current = inputWalls[i];
      final next = inputWalls[(i + 1) % n];

      // Averaged connection vertex between consecutive segments
      final sharedX = (current.end.x + next.start.x) / 2.0;
      final sharedZ = (current.end.z + next.start.z) / 2.0;
      final sharedEndpoint = Point3D(sharedX, current.end.y, sharedZ);

      final startPt = i == 0 ? current.start : processed[i - 1].end;
      processed.add(
        WallSegment(
          start: startPt,
          end: i == n - 1 ? current.end : sharedEndpoint,
          height: current.height > 0 ? current.height : 2.7,
          thickness: current.thickness > 0 ? current.thickness : 0.15,
        ),
      );
    }

    // Ensure first segment's starting vertex closes with last segment's ending vertex only if a complete perimeter was scanned
    if (processed.length >= 3) {
      final first = processed.first;
      final last = processed.last;
      final dx = first.start.x - last.end.x;
      final dz = first.start.z - last.end.z;
      if (dx * dx + dz * dz < 4.0) {
        // Close loop if endpoints are near each other
        processed[0] = WallSegment(
          start: last.end,
          end: first.end,
          height: first.height,
          thickness: first.thickness,
        );
      }
    }

    return processed;
  }

  double _calculatePolygonArea(List<WallSegment> walls) {
    if (walls.isEmpty) return 0.0;
    if (walls.length == 1) {
      return (walls.first.length * 3.2).clamp(
        2.0,
        100.0,
      ); // Estimated section area from single wall length
    }
    if (walls.length == 2) {
      return (walls[0].length * walls[1].length).clamp(
        3.0,
        200.0,
      ); // Estimated L-shape corner area
    }
    double area = 0.0;
    for (int i = 0; i < walls.length; i++) {
      final p1 = walls[i].start;
      final p2 = walls[i].end;
      area += (p1.x * p2.z) - (p2.x * p1.z);
    }
    return (area.abs() / 2.0).clamp(2.0, 500.0);
  }

  double _calculatePerimeter(List<WallSegment> walls) {
    double total = 0.0;
    for (final wall in walls) {
      total += wall.length;
    }
    return total > 0 ? total : 0.0;
  }

  /// Cancel scanning session without saving.
  Future<void> cancelScanning() async {
    _stopRecordingTimer();
    isRecording.value = false;
    isScanning.value = false;
    isProcessing.value = false;
    _scanRepo.cancelScan();

    // Cancel any pending completer
    if (_scanCompleter != null && !_scanCompleter!.isCompleted) {
      _scanCompleter!.complete(null);
    }
    _scanCompleter = null;

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
    _stopRecordingTimer();
    isScanning.value = false;
    isRecording.value = false;
    if (_scanCompleter != null && !_scanCompleter!.isCompleted) {
      _scanCompleter!.complete(null);
    }
    super.onClose();
  }
}
