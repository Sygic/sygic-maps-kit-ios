import SygicMaps

public typealias SdkInitializationCompletion = (_ success: Bool)->()

public class SYMKSdkManager {
    
    public static let shared = SYMKSdkManager()
    
    public var isSdkInitialized: Bool {
        return SYContext.isInitialized()
    }
    
    private var initializing = false
    private var completions = [SdkInitializationCompletion]()
    private let lock = DispatchSemaphore(value: 1)
    
    private init () {}
    
    public func initializeIfNeeded(_ completion: SdkInitializationCompletion?) {
        if isSdkInitialized {
            completion?(true)
            return
        }
        
        lock.wait()
        defer {
            lock.signal()
        }
        
        if let waiter = completion {
            completions.append(waiter)
        }
        guard !initializing else { return }
        initializing = true
        SYContext.initWithAppKey(SYMKApiKeys.appKey, appSecret: SYMKApiKeys.appSecret, onlineRoutingKey: "") { initResult in
            self.lock.wait()
            let success = initResult == .success
            self.initializing = false
            self.completions.forEach { block in
                block(success)
            }
            self.completions.removeAll()
            self.lock.signal()
        }
    }
    
    public func terminate() {
        guard isSdkInitialized else { return }
        SYContext.terminate()
    }
}
