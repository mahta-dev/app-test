import XCTest
@testable import Network

final class NetworkTests: XCTestCase {
    
    func testNetworkModuleCompiles() throws {
        let requestManager = RequestManager()
        XCTAssertNotNil(requestManager)
    }
    
    func testNetworkModulePublicAPI() throws {
        let requestManager: RequestManagerProtocol = RequestManager()
        let session: URLSessionProtocol = URLSession.shared
        
        XCTAssertNotNil(requestManager)
        XCTAssertNotNil(session)
    }
}
