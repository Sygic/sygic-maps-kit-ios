import SygicMaps


public typealias SdkInitializationCompletion = (_ success: Bool)->()

/// Manage initialization of SDK
public class SYMKSdkManager {
    
    // MARK: - Public Properties
    
    /// Singleton shared instance.
    public static let shared = SYMKSdkManager()
    
    /// Boolean value, whether sdk is initialized or not.
    public var isSdkInitialized: Bool {
        return SYContext.isInitialized()
    }
    
    // MARK: - Private Properties
    
    private var initializing = false
    private var completions = [SdkInitializationCompletion]()
    private let lock = DispatchSemaphore(value: 1)
    
    private init () {}

    // MARK: - Public Methods
    
    /// Initialize SDK.
    ///
    /// - Parameter completion: Completion which returns success or failure of SDK initialization.
    ///
    /// If SDK is already initialized, completion block returns success immediately. Method also
    /// handle scenario of multiple calls in the same time.
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
            DispatchQueue.main.async {
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
    }
    
    /// Terminate SDK.
    ///
    /// Call this when app is going to terminate, for example:
    /// ```
    /// func applicationWillTerminate(_ application: UIApplication) {
    ///     SYMKSdkManager.shared.terminate()
    /// }
    /// ```
    /// Otherwise SDK will crash in background.
    public func terminate() {
        guard isSdkInitialized else { return }
        SYContext.terminate()
    }
    
}
