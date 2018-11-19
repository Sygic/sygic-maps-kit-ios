import UIKit
import SygicMapsKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SYMKApiKeys.set(appKey: "sdk-test", appSecret: "rPMNrPw6PKiZiWmc17gHu7IVzOnjdAkqGUwqXPr+IG69ExNDMJZ/M7NfSg7itsuvRbcJlcTp6vX6R/bvF4MEWw==")
        return true
    }

}
