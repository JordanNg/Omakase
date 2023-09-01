import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Google Maps API Key
    if let path = Bundle.main.path(forResource: "APIKey", ofType: "plist") {
      let nsDictionary = NSDictionary(contentsOfFile: path)
      if let apiKey = nsDictionary?["apiKey"] as? String {
        GMSServices.provideAPIKey(apiKey)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
