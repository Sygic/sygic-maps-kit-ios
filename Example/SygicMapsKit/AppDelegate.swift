import UIKit
import SygicMaps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        initSygicMapsSDK()
        
        return true
    }

}

// MARK: - SDK Handling

extension AppDelegate {
    
    private func initSygicMapsSDK() {
        SYContext.initWithAppKey(SygicMapsAPI.appKey, appSecret: SygicMapsAPI.appSecret) { initResult in
            if initResult == .success {
                self.handleSygicSDKSuccess()
            } else {
                self.handleSygicSDKFailure()
            }
        }
    }
    
    private func handleSygicSDKSuccess() {
        SYOnlineSession.shared().onlineMapsEnabled = true
        NotificationCenter.default.post(name: NSNotification.Name("SDKdone"), object: nil)
    }
    
    private func handleSygicSDKFailure() {
        let alert = UIAlertController(title: "Erro", message: "Error during SDK initialization", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController = alert
    }
    
}
