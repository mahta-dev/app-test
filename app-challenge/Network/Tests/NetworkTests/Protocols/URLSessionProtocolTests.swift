import XCTest
@testable import Network

final class URLSessionProtocolTests: XCTestCase {
    
    func testURLSessionConformsToProtocol() {
        let session = URLSession.shared
        XCTAssertTrue(session is URLSessionProtocol)
    }
    
    func testMockURLSessionConformsToProtocol() {
        let mockSession = MockURLSession()
        XCTAssertTrue(mockSession is URLSessionProtocol)
    }
    
    func testURLSessionProtocolMethodSignature() {
        let session: URLSessionProtocol = URLSession.shared
        let request = URLRequest(url: URL(string: "https://example.com")!)
        
        XCTAssertTrue(session is URLSessionProtocol)
        XCTAssertNotNil(request)
    }
}
