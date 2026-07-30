import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'theme/app_theme.dart';
import 'core/di/bindings.dart';
import 'core/routes/app_routes.dart';
import 'core/storage/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Send API key to native iOS via MethodChannel
  if (Platform.isIOS) {
    const platform = MethodChannel('maps_config');
    try {
      await platform.invokeMethod('setApiKey', {
        'key': dotenv.env['GOOGLE_MAPS_KEY'],
      });
    } catch (e) {
      debugPrint("Failed to set native maps key: $e");
    }
  }

  // Protect against default White Screen of Death on iOS builds
  ErrorWidget.builder = (FlutterErrorDetails details) {
    debugPrint('=== FLUTTER ERROR CAUGHT BY ERROR WIDGET ===');
    debugPrint(details.exceptionAsString());
    if (details.stack != null) {
      debugPrintStack(stackTrace: details.stack);
    }
    debugPrint('==============================================');

    return Material(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.build_circle_outlined,
                  color: Color(0xFF155DFC),
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'PerfektWerk Workspace',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  details.exceptionAsString(),
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  };

  // Safe async initialization with timeout to guarantee runApp launches immediately
  try {
    await LocalStorage().init().timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('Storage intialization fallback: $e');
  }

  // Set preferred orientations & system overlay styles safely
  try {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.bgDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  } catch (e) {
    debugPrint('System overlay style fallback: $e');
  }

  runApp(const RoomScannerApp());
}

class RoomScannerApp extends StatelessWidget {
  const RoomScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Room Scanner 3D',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.welcome,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
      color: const Color(0xFF0F172A),
    );
  }
}
