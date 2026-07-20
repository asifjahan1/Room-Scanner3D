package com.app.liddar

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val SCANNER_CHANNEL = "com.app.liddar/scanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register ARCore scanner platform view
        flutterEngine.platformViewsController.registry
            .registerViewFactory(
                "android-arcore-view",
                ArCoreScannerViewFactory(flutterEngine.dartExecutor.binaryMessenger)
            )

        // Register scanner method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SCANNER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isSupported" -> {
                        result.success(isARCoreSupported())
                    }
                    "hasARCore" -> {
                        result.success(isARCoreSupported())
                    }
                    "startScan" -> {
                        result.success(true)
                    }
                    "stopScan" -> {
                        result.success(true)
                    }
                    "cancelScan" -> {
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun isARCoreSupported(): Boolean {
        return try {
            val availability = com.google.ar.core.ArCoreApk.getInstance()
                .checkAvailability(this)
            availability == com.google.ar.core.ArCoreApk.Availability.SUPPORTED_INSTALLED ||
                    availability == com.google.ar.core.ArCoreApk.Availability.SUPPORTED_APK_TOO_OLD ||
                    availability == com.google.ar.core.ArCoreApk.Availability.SUPPORTED_NOT_INSTALLED
        } catch (e: Exception) {
            false
        }
    }
}
