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

  /// Set export format ('pdf', 'json', 'dxf', 'usdz').
  void setFormat(String format) {
    exportFormat.value = format;
  }

  /// Perform export and immediately invoke OS share sheet.
  Future<void> exportAndShare(RoomScan scan, {bool isMetric = true}) async {
    isExporting.value = true;
    try {
      String path;
      if (exportFormat.value == 'json') {
        path = await _exportService.exportJson(scan);
      } else {
        path = await _exportService.exportPdf(scan, isMetric: isMetric);
      }
      lastExportPath.value = path;
      await _exportService.shareFile(path);
    } catch (e) {
      Get.snackbar(
        'Export Failed',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderColor: Colors.transparent,
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isExporting.value = false;
    }
  }
}
