import UIKit
import Flutter
import GoogleMaps
import Firebase


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
//    var flutter_native_splash = 1
//    UIApplication.shared.isStatusBarHidden = false
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyDsi84TWpbAsGte1tGS4GY30DbsnETG3oE")
    GeneratedPluginRegistrant.register(with: self)
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
