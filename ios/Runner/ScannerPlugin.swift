import Flutter
import UIKit

class ScannerPlugin: NSObject {
    static func register(with registrar: FlutterPluginRegistrar) {
        // Register the scanner method channel
        let channel = FlutterMethodChannel(
            name: "com.app.liddar/scanner",
            binaryMessenger: registrar.messenger()
        )

        let instance = ScannerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Register RoomPlan platform view (iOS 16+)
        if #available(iOS 16.0, *) {
            let factory = RoomPlanNativeViewFactory(messenger: registrar.messenger())
            registrar.register(factory, withId: "ios-roomplan-view")
        }
    }
}

extension ScannerPlugin: FlutterPlugin {
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isSupported":
            if #available(iOS 16.0, *) {
                // Check if device has LiDAR
                result(ARConfiguration.supportsFrameSemantics(.sceneDepth))
            } else {
                result(false)
            }
        case "hasLiDAR":
            if #available(iOS 16.0, *) {
                result(ARConfiguration.supportsFrameSemantics(.sceneDepth))
            } else {
                result(false)
            }
        case "startScan":
            // Scanning is handled by the platform view
            result(true)
        case "stopScan":
            result(true)
        case "cancelScan":
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

// Required import for AR check
import ARKit
