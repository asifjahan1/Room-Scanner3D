import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../core/storage/local_storage.dart';
import '../models/room_scan.dart';

/// Repository for CRUD operations on projects and rooms.
class ProjectRepository {
  final LocalStorage _storage = Get.find<LocalStorage>();
  final _uuid = const Uuid();

  /// Create a new project.
  Future<ScanProject> createProject(String name) async {
    final project = ScanProject(
      id: _uuid.v4(),
      name: name,
      createdAt: DateTime.now(),
    );
    await saveProject(project);
    return project;
  }

  /// Save project to persistent storage.
  Future<void> saveProject(ScanProject project) async {
    await _storage.saveProjectJson(project.id, project.toJson());
    await _updateIndex();
  }

  /// Load a single project by ID.
  Future<ScanProject?> loadProject(String projectId) async {
    final json = await _storage.loadProjectJson(projectId);
    if (json == null) return null;
    return ScanProject.fromJson(json);
  }

  /// Delete a project.
  Future<void> deleteProject(String projectId) async {
    await _storage.deleteProjectFile(projectId);
    await _updateIndex();
  }

  /// List all projects (from index for fast loading).
  List<Map<String, dynamic>> listProjectSummaries() {
    return _storage.loadProjectIndex();
  }

  /// Load all projects fully.
  Future<List<ScanProject>> loadAllProjects() async {
    final ids = await _storage.listProjectIds();
    final projects = <ScanProject>[];
    for (final id in ids) {
      final project = await loadProject(id);
      if (project != null) {
        projects.add(project);
      }
    }
    projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return projects;
  }

  /// Add a room scan to an existing project.
  Future<ScanProject> addRoomToProject(
    String projectId,
    RoomScan room,
  ) async {
    var project = await loadProject(projectId);
    project ??= ScanProject(
      id: projectId,
      name: 'Project',
      createdAt: DateTime.now(),
    );

    final updatedRooms = List<RoomScan>.from(project.rooms)..add(room);
    final updatedProject = project.copyWith(
      rooms: updatedRooms,
      updatedAt: DateTime.now(),
    );

    await saveProject(updatedProject);
    return updatedProject;
  }

  /// Update a room within a project.
  Future<void> updateRoom(
    String projectId,
    String roomId,
    RoomScan updatedRoom,
  ) async {
    final project = await loadProject(projectId);
    if (project == null) return;

    final updatedRooms = project.rooms.map((r) {
      return r.id == roomId ? updatedRoom : r;
    }).toList();

    final updatedProject = project.copyWith(
      rooms: updatedRooms,
      updatedAt: DateTime.now(),
    );

    await saveProject(updatedProject);
  }

  /// Remove a room from a project.
  Future<void> removeRoom(String projectId, String roomId) async {
    final project = await loadProject(projectId);
    if (project == null) return;

    final updatedRooms = project.rooms.where((r) => r.id != roomId).toList();
    final updatedProject = project.copyWith(
      rooms: updatedRooms,
      updatedAt: DateTime.now(),
    );

    await saveProject(updatedProject);
  }

  /// Update the project index for fast home screen loading.
  Future<void> _updateIndex() async {
    final projects = await loadAllProjects();
    final index = projects.map((p) => {
          'id': p.id,
          'name': p.name,
          'createdAt': p.createdAt.toIso8601String(),
          'roomCount': p.rooms.length,
          'totalArea': p.totalArea,
        }).toList();
    await _storage.saveProjectIndex(index);
  }
}
