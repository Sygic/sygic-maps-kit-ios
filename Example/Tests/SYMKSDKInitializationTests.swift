import Quick
import Nimble
import SygicMapsKit

class SDKInitializationTest: QuickSpec {
    
    override func spec() {
        describe("SDK initialization") {
            
            beforeEach {
                SYMKApiKeys.set(appKey: "", appSecret: "", routingKey: "")
            }
            
            it("should not finish without key") {
                var initializationResult: Bool?
                SYMKSdkManager.shared.initializeIfNeeded({ (result) in
                    initializationResult = result
                })
                expect(initializationResult).toEventually(equal(false), timeout: 5)
            }
            
            it("should not finish with incorrect key") {
                var initializationResult: Bool?
                // incorrect key
                let appKey = ProcessInfo.processInfo.environment["SDK_APP_KEY"] ?? ""
                SYMKApiKeys.set(appKey: appKey, appSecret: "fweferfSdnGUzpZ7XI+h7+lna3IslJrewfNTHIxyiZlpjgR7aX1Nz9jaw4Z4rVJtLZkOxyh0AL1q+dwefwfwf", routingKey: "")
                SYMKSdkManager.shared.initializeIfNeeded({ (result) in
                    initializationResult = result
                })
                expect(initializationResult).toEventually(equal(false), timeout: 10)
            }
            
            it("should initialize succesfully") {
                var initializationResult: Bool?
                // correct test key
                let appKey = ProcessInfo.processInfo.environment["SDK_APP_KEY"] ?? ""
                let appSecret = ProcessInfo.processInfo.environment["SDK_APP_SECRET"] ?? ""
                let appRouting = ProcessInfo.processInfo.environment["SDK_APP_ROUTING"] ?? ""
                
                SYMKApiKeys.set(appKey: appKey, appSecret: appSecret, routingKey: appRouting)
                SYMKSdkManager.shared.initializeIfNeeded({ (result) in
                    initializationResult = result
                })
                expect(initializationResult).toEventually(equal(true), timeout: 10)
            }
            
            afterEach {
                SYMKSdkManager.shared.terminate()
            }
        }
    }
    
}
