import XCTest
@testable import Network

final class IntExtensionsTests: XCTestCase {
    
    func testServerErrorThreshold() {
        XCTAssertEqual(Int.serverErrorThreshold, 500)
    }
    
    func testDefaultRetryCount() {
        XCTAssertEqual(Int.defaultRetryCount, 3)
    }
    
    func testServerErrorThresholdType() {
        XCTAssertTrue(Int.serverErrorThreshold is Int)
    }
    
    func testDefaultRetryCountType() {
        XCTAssertTrue(Int.defaultRetryCount is Int)
    }
}
