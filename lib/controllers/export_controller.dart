import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/room_scan.dart';
import '../services/export_service.dart';

/// GetX controller managing multi-format export pipeline and sharing.
class ExportController extends GetxController {
  final ExportService _exportService = ExportService();
  final isExporting = false.obs;
  final exportProgress = 0.0.obs;
  final exportFormat = 'pdf'.obs;
  final lastExportPath = Rxn<String>();

  /// Supported CAD and document formats: 'pdf', 'dxf', 'svg', 'obj', 'glb', 'json'
  final List<String> availableFormats = ['pdf', 'dxf', 'svg', 'obj', 'glb', 'json'];

  /// Set active export format ('pdf', 'dxf', 'svg', 'obj', 'glb', 'json').
  void setFormat(String format) {
    exportFormat.value = format.toLowerCase();
  }

  /// Perform high-accuracy engineering export and immediately invoke OS share sheet.
  Future<void> exportAndShare(RoomScan scan, {bool isMetric = true}) async {
    isExporting.value = true;
    exportProgress.value = 0.2;
    try {
      final path = await _exportService.exportToFile(
        scan,
        exportFormat.value,
        isMetric: isMetric,
      );
      exportProgress.value = 0.8;
      lastExportPath.value = path;
      await _exportService.shareFile(path);
      exportProgress.value = 1.0;
    } catch (e) {
      Get.snackbar(
        'Export Failed',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.error_outline, color: Colors.white),
        backgroundColor: const Color(0xFFD90429),
        colorText: Colors.white,
        borderColor: Colors.transparent,
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isExporting.value = false;
      exportProgress.value = 0.0;
    }
  }
}
