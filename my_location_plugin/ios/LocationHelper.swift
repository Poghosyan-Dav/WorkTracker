import Flutter
import CoreLocation
import UserNotifications

public class SwiftLocationPlugin: NSObject, FlutterPlugin {
    var locationChannel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "my_location_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftLocationPlugin()
        instance.locationChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            handleInitialize(result: result)
        case "startLocationUpdates":
            handleStartLocationUpdates(result: result)
        case "fetchSomeData":
            handleFetchSomeData(result: result)
        // Add handlers for other methods
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleInitialize(result: FlutterResult) {
        // Implement initialization code here
        LocationManager.shared.setup()
        result(nil)
    }

    private func handleStartLocationUpdates(result: FlutterResult) {
        // Implement code to start location updates
        LocationManager.shared.startUpdatingLocation()
        result(nil)
    }

    private func handleFetchSomeData(result: FlutterResult) {
        // Implement code to fetch data
        fetchSomeData { (bool) in
            result(bool)
        }
    }

    private func fetchSomeData(completion: @escaping (Bool) -> ()) {
        LocationHelper.shared.updateUser { (bool) in
            let date = DateFormatter.sharedDateFormatter.string(from: Date())
            UserDefaults.standard.set(date, forKey: "LastBackgroundFetch")
            completion(bool)
        }
    }
}
