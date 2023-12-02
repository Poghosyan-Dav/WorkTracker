import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
var locationChannel: FlutterMethodChannel?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBcyQLDXR2Rik1yTHLPBQD3XnxIhUOnW60")
    GeneratedPluginRegistrant.register(with: self)

      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

        locationChannel = FlutterMethodChannel(name: "my_location_plugin", binaryMessenger: controller.binaryMessenger)
        locationChannel?.setMethodCallHandler(handleLocationMethodCall)


    // here, Without this code the task will not work.
    SwiftFlutterForegroundTaskPlugin.setPluginRegistrantCallback(registerPlugins)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  func handleLocationMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "initialize":
          // Implement initialization code here
          print("Handling 'initialize' method")
          result(nil)
      case "startLocationUpdates":
          // Implement code to start location updates
          print("Handling 'startLocationUpdates' method")
          result(nil)
      // Add handlers for other methods
      default:
          print("Method not implemented: \(call.method)")
          result(FlutterMethodNotImplemented)
      }
  }

}

// here
func registerPlugins(registry: FlutterPluginRegistry) {
  GeneratedPluginRegistrant.register(with: registry)
}
