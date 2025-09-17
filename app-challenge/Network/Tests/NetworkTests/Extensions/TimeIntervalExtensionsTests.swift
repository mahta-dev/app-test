import XCTest
@testable import Network

final class TimeIntervalExtensionsTests: XCTestCase {
    
    func testNanosecondsPerSecond() {
        XCTAssertEqual(TimeInterval.nanosecondsPerSecond, 1_000_000_000)
    }
    
    func testNanosecondsPerSecondType() {
        XCTAssertTrue(TimeInterval.nanosecondsPerSecond is TimeInterval)
    }
}
