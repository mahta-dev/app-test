import XCTest
@testable import Network

final class RequestManagerProtocolTests: XCTestCase {
    
    func testRequestManagerConformsToProtocol() {
        let requestManager = RequestManager()
        XCTAssertTrue(requestManager is RequestManagerProtocol)
    }
    
    func testRequestManagerProtocolMethodSignature() {
        let requestManager: RequestManagerProtocol = RequestManager()
        let endpoint = MockEndpoint()
        
        XCTAssertTrue(requestManager is RequestManagerProtocol)
        XCTAssertNotNil(endpoint)
    }
    
    func testRequestManagerProtocolGenericType() {
        let requestManager: RequestManagerProtocol = RequestManager()
        let endpoint = MockEndpoint()
        
        let task: Task<MockResponse, Error> = Task {
            try await requestManager.request(endpoint: endpoint)
        }
        
        XCTAssertNotNil(task)
    }
}
