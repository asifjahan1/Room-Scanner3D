import 'package:get/get.dart';
import '../../models/room_scan.dart';
import '../../screens/home_screen.dart';
import '../../screens/scanning_screen.dart';
import '../../screens/scan_complete_screen.dart';
import '../../screens/room_label_screen.dart';
import '../../screens/floor_plan_screen.dart';
import '../../screens/project_detail_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/onboarding/welcome_screen.dart';
import '../../screens/onboarding/invitation_screen.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/sign_up_screen.dart';
import '../../screens/auth/verify_email_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/weather/weather_screen.dart';
import '../../screens/shift/shift_ended_screen.dart';
import '../../screens/my_day/my_day_timeline_screen.dart';
import '../../screens/my_day/sync_complete_screen.dart';
import '../../screens/jobs/job_details_screen.dart';
import '../../screens/tasks/task_detail_screen.dart';
import '../../screens/tasks/voice_update_screen.dart';
import '../../screens/tasks/offline_work_screen.dart';
import '../../screens/progress/update_progress_screen.dart';
import '../../screens/progress/progress_sent_screen.dart';
import '../../screens/analysis/ubakus_analysis_screen.dart';
import '../../screens/materials/material_requests_screen.dart';
import '../../screens/materials/create_material_request_screen.dart';
import '../../screens/materials/material_request_sent_screen.dart';
import '../../screens/messages/project_chat_screen.dart';
import '../../screens/more/my_calendar_screen.dart';
import '../../screens/more/my_schedule_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/profile/profile_and_settings_screen.dart';
import '../../screens/profile/app_preferences_screen.dart';
import '../../screens/profile/notification_preferences_screen.dart';
import '../../screens/profile/security_settings_screen.dart';
import '../../screens/profile/language_settings_screen.dart';
import '../../screens/profile/legal_docs_screens.dart';
import '../../screens/profile/device_permissions_screen.dart';
import '../../screens/profile/data_export_screen.dart';
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

  // PerfektWerk OS Routes
  static const String welcome = '/welcome';
  static const String invitation = '/invitation';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String verifyEmail = '/verify-email';
  static const String dashboard = '/dashboard';
  static const String weather = '/weather';
  static const String shiftEnded = '/shift-ended';
  static const String myDayTimeline = '/my-day-timeline';
  static const String syncComplete = '/sync-complete';
  static const String jobDetails = '/job-details';
  static const String taskDetail = '/task-detail';
  static const String voiceUpdate = '/voice-update';
  static const String offlineWork = '/offline-work';
  static const String updateProgress = '/update-progress';
  static const String progressSent = '/progress-sent';
  static const String ubakusAnalysis = '/ubakus-analysis';
  static const String materialRequests = '/material-requests';
  static const String createMaterialRequest = '/create-material-request';
  static const String materialRequestSent = '/material-request-sent';
  static const String projectChat = '/project-chat';
  static const String myCalendar = '/my-calendar';
  static const String mySchedule = '/my-schedule';
  static const String notifications = '/notifications';
  
  // Section 11 Profile & Settings Routes
  static const String profileAndSettings = '/profile-and-settings';
  static const String appPreferences = '/app-preferences';
  static const String notificationPreferences = '/notification-preferences';
  static const String securitySettings = '/security-settings';
  static const String languageSettings = '/language-settings';
  static const String termsOfUse = '/terms-of-use';
  static const String privacyPolicy = '/privacy-policy';
  static const String impressum = '/impressum';
  static const String devicePermissions = '/device-permissions';
  static const String dataExport = '/data-export';

  static List<GetPage> get pages => [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(
      name: scanning,
      page: () => const ScanningScreen(),
      binding: ScanningBinding(),
    ),
    GetPage(name: scanComplete, page: () => const ScanCompleteScreen()),
    GetPage(name: roomLabel, page: () => const RoomLabelScreen()),
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
    GetPage(name: projectDetail, page: () => const ProjectDetailScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
    // PerfektWerk OS Pages
    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(name: invitation, page: () => const InvitationScreen()),
    GetPage(name: signIn, page: () => const SignInScreen()),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    GetPage(name: verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: weather, page: () => const WeatherScreen()),
    GetPage(name: shiftEnded, page: () => const ShiftEndedScreen()),
    GetPage(name: myDayTimeline, page: () => const MyDayTimelineScreen()),
    GetPage(name: syncComplete, page: () => const SyncCompleteScreen()),
    GetPage(name: jobDetails, page: () => const JobDetailsScreen()),
    GetPage(name: taskDetail, page: () => const TaskDetailScreen()),
    GetPage(name: voiceUpdate, page: () => const VoiceUpdateScreen()),
    GetPage(name: offlineWork, page: () => const OfflineWorkScreen()),
    GetPage(name: updateProgress, page: () => const UpdateProgressScreen()),
    GetPage(name: progressSent, page: () => const ProgressSentScreen()),
    GetPage(name: ubakusAnalysis, page: () => const UbakusAnalysisScreen()),
    GetPage(name: materialRequests, page: () => const MaterialRequestsScreen()),
    GetPage(
      name: createMaterialRequest,
      page: () => const CreateMaterialRequestScreen(),
    ),
    GetPage(
      name: materialRequestSent,
      page: () => const MaterialRequestSentScreen(),
    ),
    GetPage(name: projectChat, page: () => const ProjectChatScreen()),
    GetPage(name: myCalendar, page: () => const MyCalendarScreen()),
    GetPage(name: mySchedule, page: () => const MyScheduleScreen()),
    GetPage(name: notifications, page: () => const NotificationsScreen()),
    GetPage(name: profileAndSettings, page: () => const ProfileAndSettingsScreen()),
    GetPage(name: appPreferences, page: () => const AppPreferencesScreen()),
    GetPage(name: notificationPreferences, page: () => const NotificationPreferencesScreen()),
    GetPage(name: securitySettings, page: () => const SecuritySettingsScreen()),
    GetPage(name: languageSettings, page: () => const LanguageSettingsScreen()),
    GetPage(name: termsOfUse, page: () => const TermsOfUseScreen()),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicyScreen()),
    GetPage(name: impressum, page: () => const ImpressumScreen()),
    GetPage(name: devicePermissions, page: () => const DevicePermissionsScreen()),
    GetPage(name: dataExport, page: () => const DataExportScreen()),
  ];
}
