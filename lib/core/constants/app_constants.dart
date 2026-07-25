/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Room Scanner 3D';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyProjects = 'projects';
  static const String keySettings = 'settings';
  static const String keyUnitPreference = 'unit_preference';
  static const String keyThemeMode = 'theme_mode';
  static const String keyDefaultExportFormat = 'default_export_format';

  // Scanning
  static const double defaultWallHeight = 2.6; // meters
  static const double defaultWallThickness = 0.15; // meters
  static const double minWallLength = 0.3; // meters
  static const double wallMergeThreshold = 0.6; // meters
  static const double planeMergeThreshold = 0.4; // meters
  static const int maxUndoSteps = 50;

  // Export
  static const double pdfPageWidth = 595.28; // A4 points
  static const double pdfPageHeight = 841.89;
  static const double pngExportScale = 3.0; // 3x resolution

  // Platform Channel Names
  static const String scannerChannel = 'com.app.liddar/scanner';
  static const String scannerEventsChannel = 'com.app.liddar/scanner_events';

  // Device Capability Tiers
  static const String tierLidar = 'TIER_LIDAR';
  static const String tierArcoreDepth = 'TIER_ARCORE_DEPTH';
  static const String tierArcoreBasic = 'TIER_ARCORE_BASIC';
  static const String tierCameraSensor = 'TIER_CAMERA_SENSOR';

  // Room Types
  static const Map<String, String> roomTypeIcons = {
    'bedroom': '🛏️',
    'living_room': '🛋️',
    'kitchen': '🍳',
    'bathroom': '🚿',
    'office': '💼',
    'dining_room': '🍽️',
    'garage': '🚗',
    'hallway': '🚪',
    'balcony': '🌿',
    'custom': '📐',
  };
}
