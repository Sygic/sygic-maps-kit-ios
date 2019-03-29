import XCTest
import SygicMapsKit

class ZZZSDKTerminateTest: XCTestCase {
    
    override func tearDown() {
        SYMKSdkManager.shared.terminate()
        super.tearDown()
    }
    
    func testDumy() {
        XCTAssertTrue(true, "this is just dummy test for correct SDK termination")
    }
    
}
