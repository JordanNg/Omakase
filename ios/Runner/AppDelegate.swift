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
    GMSServices.provideAPIKey("AIzaSyCDqaEZmWOGUGrJ5JxsxWrXRti8ij01_iE")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
