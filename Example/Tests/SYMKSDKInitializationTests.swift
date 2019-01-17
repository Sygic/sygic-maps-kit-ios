import Quick
import Nimble
import SygicMapsKit

class SDKInitializationTest: QuickSpec {
    
    override func spec() {
        describe("SDK initialization") {
            
            beforeEach {
                SYMKApiKeys.set(appKey: "", appSecret: "")
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
                SYMKApiKeys.set(appKey: "sygic.ios.maps.sampleees", appSecret: "/nisSdnGUzpZ7XI+h7+lna3IslJfNTHIxyiZlpjgR7aX1Nz12345Z4rVJtLZkOxyh0AL1q+k0qhHshga12d/jg==")
                SYMKSdkManager.shared.initializeIfNeeded({ (result) in
                    initializationResult = result
                })
                expect(initializationResult).toEventually(equal(false), timeout: 10)
            }
            
            it("should initialize succesfully") {
                var initializationResult: Bool?
                // correct test key
                SYMKApiKeys.set(appKey: "sygic.ios.maps.sample", appSecret: "/nisSdnGUzpZ7XI+h7+lna3IslJfNTHIxyiZlpjgR7aX1Nz9jaw4Z4rVJtLZkOxyh0AL1q+k0qhHshga12d/jg==")
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
