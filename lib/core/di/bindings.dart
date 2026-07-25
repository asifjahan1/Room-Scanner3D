import 'package:get/get.dart';
import '../storage/local_storage.dart';
import '../../repositories/project_repository.dart';
import '../../repositories/scan_repository.dart';
import '../../services/export_service.dart';
import '../../controllers/project_controller.dart';
import '../../controllers/scanning_controller.dart';
import '../../controllers/floor_plan_controller.dart';
import '../../controllers/export_controller.dart';

/// Root binding — registers all global services at app startup.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services (permanent singletons)
    Get.put(LocalStorage(), permanent: true);

    // Repositories
    Get.lazyPut<ProjectRepository>(() => ProjectRepository(), fenix: true);
    Get.lazyPut<ScanRepository>(() => ScanRepository(), fenix: true);

    // Services
    Get.lazyPut<ExportService>(() => ExportService(), fenix: true);

    // Global Controllers
    Get.put(ProjectController(), permanent: true);
  }
}

/// Binding for Scanning feature screens.
class ScanningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanningController>(() => ScanningController());
  }
}

/// Binding for Floor Plan editor screen.
class FloorPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FloorPlanController>(() => FloorPlanController());
  }
}

/// Binding for Export functionality.
class ExportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExportController>(() => ExportController());
  }
}
