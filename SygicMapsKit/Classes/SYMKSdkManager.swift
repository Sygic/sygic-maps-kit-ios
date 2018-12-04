import SygicMaps

public typealias SdkInitializationCompletion = (_ success: Bool)->()

public class SYMKSdkManager {
    
    static let shared = SYMKSdkManager()
    
    private var initializing = false
    private var completions = [SdkInitializationCompletion]()
    
    public var isSdkInitialized: Bool {
        return SYContext.isInitialized()
    }
    
    public func initailizeIfNeeded(_ completion: SdkInitializationCompletion?) {
        if isSdkInitialized {
            completion?(true)
            return
        }
        if let waiter = completion {
            completions.append(waiter)
        }
        guard !initializing else { return }
        initializing = true
        SYContext.initWithAppKey(SYMKApiKeys.appKey, appSecret: SYMKApiKeys.appSecret) { initResult in
            let success = initResult == .success
            self.initializing = false
            self.completions.forEach { block in
                block(success)
            }
            self.completions.removeAll()
        }
    }
}
