import 'package:get/get.dart';
import '../models/room_scan.dart';
import '../repositories/project_repository.dart';

/// GetX controller managing projects list and active project.
class ProjectController extends GetxController {
  final projects = <ScanProject>[].obs;
  final currentProject = Rxn<ScanProject>();
  final isLoading = false.obs;

  ProjectRepository get _repo => Get.find<ProjectRepository>();

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  /// Load all projects from storage.
  Future<void> loadProjects() async {
    isLoading.value = true;
    try {
      final loaded = await _repo.loadAllProjects();
      projects.assignAll(loaded);
    } catch (e) {
      Get.log('Error loading projects: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new project.
  Future<ScanProject> createProject(String name) async {
    final project = await _repo.createProject(name);
    projects.insert(0, project);
    currentProject.value = project;
    return project;
  }

  /// Delete a project.
  Future<void> deleteProject(String projectId) async {
    await _repo.deleteProject(projectId);
    projects.removeWhere((p) => p.id == projectId);
    if (currentProject.value?.id == projectId) {
      currentProject.value = null;
    }
  }

  /// Set active project.
  void setCurrentProject(ScanProject project) {
    currentProject.value = project;
  }

  /// Add a room scan to the current project (or create default project).
  Future<void> addRoomToCurrentProject(RoomScan room) async {
    var project = currentProject.value;
    project ??= await createProject('My Project');

    final updated = await _repo.addRoomToProject(project.id, room);
    currentProject.value = updated;

    // Refresh projects list
    final idx = projects.indexWhere((p) => p.id == updated.id);
    if (idx >= 0) {
      projects[idx] = updated;
    } else {
      projects.insert(0, updated);
    }
  }

  /// Update a room in the current project.
  Future<void> updateRoom(String roomId, RoomScan updatedRoom) async {
    final project = currentProject.value;
    if (project == null) return;

    await _repo.updateRoom(project.id, roomId, updatedRoom);
    await loadProjects();

    // Refresh current project
    currentProject.value = await _repo.loadProject(project.id);
  }

  /// Get recent scans across all projects (last 5).
  List<RoomScan> get recentScans {
    final allRooms = <RoomScan>[];
    for (final project in projects) {
      allRooms.addAll(project.rooms);
    }
    allRooms.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    return allRooms.take(5).toList();
  }
}
