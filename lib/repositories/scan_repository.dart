import '../models/room_scan.dart';
import '../services/scanner_service.dart';

/// Repository managing active scan state and bridging native results → Dart models.
class ScanRepository {
  RoomScan? _activeScan;
  final List<RoomScan> _scanHistory = [];

  RoomScan? get activeScan => _activeScan;
  List<RoomScan> get scanHistory => List.unmodifiable(_scanHistory);

  /// Create a new active scan session.
  void startNewScan(String scanId) {
    _activeScan = RoomScan(
      id: scanId,
      scannedAt: DateTime.now(),
      status: ScanStatus.scanning,
    );
  }

  /// Update active scan with progress data.
  void updateScanProgress({
    int? wallsDetected,
    int? openingsDetected,
    double? percentage,
    String? message,
  }) {
    if (_activeScan == null) return;
    // Progress is tracked in the controller, not stored in the model
  }

  /// Complete the active scan with native result data.
  RoomScan completeScan(Map<String, dynamic> nativeResult) {
    final room = ScannerService.parseScanResult(nativeResult);
    _activeScan = room;
    _scanHistory.add(room);
    return room;
  }

  /// Cancel the active scan.
  void cancelScan() {
    _activeScan = null;
  }

  /// Clear scan history.
  void clearHistory() {
    _scanHistory.clear();
  }
}
