import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    if let mapsRegistrar = self.registrar(forPlugin: "MapsConfigPlugin") {
      let channel = FlutterMethodChannel(name: "maps_config", binaryMessenger: mapsRegistrar.messenger())
      channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "setApiKey" {
          if let args = call.arguments as? [String: Any], let key = args["key"] as? String {
            GMSServices.provideAPIKey(key)
            result(true)
          } else {
            result(FlutterError(code: "INVALID_ARG", message: "Key not provided", details: nil))
          }
        } else {
          result(FlutterMethodNotImplemented)
        }
      })
    }

    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ScannerPlugin") {
      ScannerPlugin.register(with: registrar)
    }
  }
}
