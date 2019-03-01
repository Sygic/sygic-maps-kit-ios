import UIKit
import SygicMapsKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SYMKApiKeys.set(appKey: "", appSecret: "")
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SYMKSdkManager.shared.terminate()
    }

}
