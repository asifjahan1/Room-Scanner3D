import 'dart:io';
import 'package:flutter/services.dart';
import '../models/room_scan.dart';

/// Service that bridges Flutter and native platform scanning capabilities.
/// iOS: Uses Apple RoomPlan API
/// Android: Uses ARCore Depth API + custom mesh processing
class ScannerService {
  static const MethodChannel _channel = MethodChannel('com.app.liddar/scanner');
  static const EventChannel _eventChannel = EventChannel(
    'com.app.liddar/scanner_events',
  );

  /// Check if the device supports room scanning
  static Future<bool> isSupported() async {
    try {
      final result = await _channel.invokeMethod<bool>('isSupported');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Check if LiDAR sensor is available (iOS only)
  static Future<bool> hasLiDAR() async {
    if (!Platform.isIOS) return false;
    try {
      final result = await _channel.invokeMethod<bool>('hasLiDAR');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Check if ARCore is available (Android only)
  static Future<bool> hasARCore() async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('hasARCore');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Get the scanning technology name for current platform
  static String get scanningTechnology {
    if (Platform.isIOS) return 'LiDAR + RoomPlan';
    if (Platform.isAndroid) return 'ARCore Depth';
    return 'Unsupported';
  }

  /// Start a new room scan session
  static Future<void> startScan() async {
    try {
      await _channel.invokeMethod('startScan');
    } on PlatformException catch (e) {
      throw ScanException('Failed to start scan: ${e.message}');
    }
  }

  /// Stop the current scan and get results
  static Future<Map<String, dynamic>?> stopScan() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'stopScan',
      );
      return result?.cast<String, dynamic>();
    } on PlatformException catch (e) {
      throw ScanException('Failed to stop scan: ${e.message}');
    }
  }

  /// Cancel the current scan without saving
  static Future<void> cancelScan() async {
    try {
      await _channel.invokeMethod('cancelScan');
    } on PlatformException catch (e) {
      throw ScanException('Failed to cancel scan: ${e.message}');
    }
  }

  /// Get scan progress events stream
  static Stream<ScanProgress> get scanProgressStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      final data = Map<String, dynamic>.from(event as Map);
      return ScanProgress.fromJson(data);
    });
  }

  /// Parse scan result from native platform into RoomScan model
  static RoomScan parseScanResult(Map<String, dynamic> nativeResult) {
    final walls = <WallSegment>[];
    final openings = <Opening>[];
    final floorPoints = <Point3D>[];

    if (nativeResult.containsKey('walls')) {
      for (final wall in (nativeResult['walls'] as List)) {
        walls.add(WallSegment.fromJson(Map<String, dynamic>.from(wall as Map)));
      }
    }

    if (nativeResult.containsKey('openings')) {
      for (final opening in (nativeResult['openings'] as List)) {
        openings.add(
          Opening.fromJson(Map<String, dynamic>.from(opening as Map)),
        );
      }
    }

    if (nativeResult.containsKey('floorBoundary')) {
      for (final point in (nativeResult['floorBoundary'] as List)) {
        floorPoints.add(
          Point3D.fromJson(Map<String, dynamic>.from(point as Map)),
        );
      }
    }

    return RoomScan(
      id:
          nativeResult['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      scannedAt: DateTime.now(),
      walls: walls,
      openings: openings,
      floorBoundary: floorPoints,
      area: (nativeResult['area'] as num?)?.toDouble(),
      perimeter: (nativeResult['perimeter'] as num?)?.toDouble(),
      status: ScanStatus.completed,
      usdzFilePath: nativeResult['usdzPath'] as String?,
      jsonFilePath: nativeResult['jsonPath'] as String?,
    );
  }
}

/// Progress information during scanning
class ScanProgress {
  final double percentage;
  final int wallsDetected;
  final int openingsDetected;
  final String message;

  const ScanProgress({
    required this.percentage,
    required this.wallsDetected,
    required this.openingsDetected,
    required this.message,
  });

  factory ScanProgress.fromJson(Map<String, dynamic> json) {
    return ScanProgress(
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      wallsDetected: (json['wallsDetected'] as num?)?.toInt() ?? 0,
      openingsDetected: (json['openingsDetected'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
    );
  }
}

/// Custom exception for scanner errors
class ScanException implements Exception {
  final String message;
  ScanException(this.message);

  @override
  String toString() => 'ScanException: $message';
}
