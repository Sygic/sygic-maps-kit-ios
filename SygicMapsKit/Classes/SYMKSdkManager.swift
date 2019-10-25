//// SYMKSdkManager.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the &quot;Software&quot;), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SygicMaps


public typealias SdkInitializationCompletion = (_ success: Bool)->()

/// Manage initialization of SDK
public class SYMKSdkManager {
    
    // MARK: - Public Properties
    
    /// Singleton shared instance.
    public static let shared = SYMKSdkManager()
    
    /// Boolean value, whether Sygic SDK is using online or offline maps.
    public var onlineMapsEnabled = true {
        didSet {
            if isSdkInitialized {
                SYOnlineSession.shared().onlineMapsEnabled = onlineMapsEnabled
            }
        }
    }
    
    /// Path to custom map skins
    public var customSkinPath: String?
    
    /// Boolean value, whether sdk is initialized or not.
    public var isSdkInitialized: Bool {
        return SYContext.isInitialized()
    }
    
    public typealias SYMKSdkSettings = [AnyHashable:Any]
    
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
        
        SYContext.initWithConfiguration(customSdkSettings()) { initResult in
            DispatchQueue.main.async {
                self.lock.wait()
                let success = initResult == .success
                self.initializing = false
                if (success) {
                    SYOnlineSession.shared().onlineMapsEnabled = self.onlineMapsEnabled
                }
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
    
    private func customSdkSettings() -> SYMKSdkSettings {
        var settings: SYMKSdkSettings = [:]
        settings["Authentication"] = ["app_key": SYMKApiKeys.appKey,
                                      "app_secret": SYMKApiKeys.appSecret]
        settings["Online"] = ["Search": ["url": "https://searchtest.api.sygic.com/"]]
        if let skins = customSkinPath {
            settings["StorageFolders"] = ["skin": skins]
        }
        return settings
    }
}
