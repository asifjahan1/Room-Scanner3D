import 'package:get/get.dart';
import '../../models/room_scan.dart';
import '../../screens/home_screen.dart';
import '../../screens/scanning_screen.dart';
import '../../screens/scan_complete_screen.dart';
import '../../screens/room_label_screen.dart';
import '../../screens/floor_plan_screen.dart';
import '../../screens/project_detail_screen.dart';
import '../../screens/settings_screen.dart';
import '../di/bindings.dart';

/// Named route constants and GetPage definitions.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String scanning = '/scanning';
  static const String scanComplete = '/scan-complete';
  static const String roomLabel = '/room-label';
  static const String floorPlan = '/floor-plan';
  static const String projectDetail = '/project-detail';
  static const String settings = '/settings';

  static List<GetPage> get pages => [
        GetPage(
          name: home,
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: scanning,
          page: () => const ScanningScreen(),
          binding: ScanningBinding(),
        ),
        GetPage(
          name: scanComplete,
          page: () => const ScanCompleteScreen(),
        ),
        GetPage(
          name: roomLabel,
          page: () => const RoomLabelScreen(),
        ),
        GetPage(
          name: floorPlan,
          page: () {
            final scan = Get.arguments as RoomScan?;
            return FloorPlanScreen(
              roomLabel: scan?.label ?? 'Room',
              roomScan: scan,
            );
          },
          binding: FloorPlanBinding(),
        ),
        GetPage(
          name: projectDetail,
          page: () => const ProjectDetailScreen(),
        ),
        GetPage(
          name: settings,
          page: () => const SettingsScreen(),
        ),
      ];
}
