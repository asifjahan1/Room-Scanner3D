import Flutter
import UIKit
import ARKit
#if canImport(RoomPlan)
import RoomPlan
#endif

public class ScannerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.app.liddar/scanner", binaryMessenger: registrar.messenger())
        let instance = ScannerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Register universal room scanner view factory for both LiDAR and non-LiDAR hardware
        let factory = RoomPlanViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "com.app.liddar/room_plan_view")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isSupported":
            var isSupported = false
            #if canImport(RoomPlan)
            if #available(iOS 16.0, *) {
                isSupported = RoomCaptureSession.isSupported || ARWorldTrackingConfiguration.isSupported
            } else {
                isSupported = ARWorldTrackingConfiguration.isSupported
            }
            #else
            isSupported = ARWorldTrackingConfiguration.isSupported
            #endif
            result(isSupported)
        case "hasLidar":
            var hasLidar = false
            if #available(iOS 14.0, *) {
                hasLidar = ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth)
            }
            result(hasLidar)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

/**
 * Dynamic factory routing between Pro LiDAR RoomPlan on supported hardware
 * and our high-precision ARKit Floor-to-Wall fallback engine on standard iOS devices.
 */
class RoomPlanViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        #if canImport(RoomPlan)
        if #available(iOS 16.0, *) {
            if RoomCaptureSession.isSupported {
                return RoomPlanNativeView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
            }
        }
        #endif
        // Fallback to high-accuracy ARKit floor boundary RANSAC scanning for non-LiDAR devices!
        return ARKitFloorBoundaryView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
