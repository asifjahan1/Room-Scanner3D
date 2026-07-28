import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../constants/app_constants.dart';

/// Persistent local storage service for projects, settings, and scan data.
/// Uses GetStorage for settings and JSON file I/O for project data.
class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  GetStorage? _box;
  String? _documentsPath;

  /// Initialize storage safely. Call once at app startup.
  Future<void> init() async {
    try {
      await GetStorage.init();
      _box = GetStorage();
    } catch (e) {
      _box = null;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      _documentsPath = dir.path;

      // Ensure projects directory exists
      final projectsDir = Directory('$_documentsPath/projects');
      if (!await projectsDir.exists()) {
        await projectsDir.create(recursive: true);
      }

      // Ensure exports directory exists
      final exportsDir = Directory('$_documentsPath/exports');
      if (!await exportsDir.exists()) {
        await exportsDir.create(recursive: true);
      }
    } catch (e) {
      _documentsPath = '';
    }
  }

  String get documentsPath => _documentsPath ?? '';
  String get projectsPath => '$_documentsPath/projects';
  String get exportsPath => '$_documentsPath/exports';

  // ─── Settings ───

  bool get isMetric => _box?.read<bool>(AppConstants.keyUnitPreference) ?? true;
  set isMetric(bool value) => _box?.write(AppConstants.keyUnitPreference, value);

  String get themeMode =>
      _box?.read<String>(AppConstants.keyThemeMode) ?? 'dark';
  set themeMode(String value) => _box?.write(AppConstants.keyThemeMode, value);

  String get defaultExportFormat =>
      _box?.read<String>(AppConstants.keyDefaultExportFormat) ?? 'pdf';
  set defaultExportFormat(String value) =>
      _box?.write(AppConstants.keyDefaultExportFormat, value);

  // ─── Project File I/O ───

  /// Save project JSON to file.
  Future<void> saveProjectJson(String projectId, Map<String, dynamic> data) async {
    final file = File('$projectsPath/$projectId.json');
    await file.writeAsString(jsonEncode(data));
  }

  /// Load project JSON from file.
  Future<Map<String, dynamic>?> loadProjectJson(String projectId) async {
    final file = File('$projectsPath/$projectId.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      return jsonDecode(content) as Map<String, dynamic>;
    }
    return null;
  }

  /// Delete project file.
  Future<void> deleteProjectFile(String projectId) async {
    final file = File('$projectsPath/$projectId.json');
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// List all project IDs from saved files.
  Future<List<String>> listProjectIds() async {
    final dir = Directory(projectsPath);
    if (!await dir.exists()) return [];

    final files = await dir
        .list()
        .where((f) => f.path.endsWith('.json'))
        .toList();

    return files.map((f) {
      final name = f.uri.pathSegments.last;
      return name.replaceAll('.json', '');
    }).toList();
  }

  // ─── Project Index (fast metadata lookup) ───

  /// Save project index (list of project summaries) for fast home screen loading.
  Future<void> saveProjectIndex(List<Map<String, dynamic>> index) async {
    _box?.write(AppConstants.keyProjects, jsonEncode(index));
  }

  /// Load project index.
  List<Map<String, dynamic>> loadProjectIndex() {
    final raw = _box?.read<String>(AppConstants.keyProjects);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded.cast<Map<String, dynamic>>();
  }
}
