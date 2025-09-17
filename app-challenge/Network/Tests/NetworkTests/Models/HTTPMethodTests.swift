import XCTest
@testable import Network

final class HTTPMethodTests: XCTestCase {
    
    func testHTTPMethodRawValues() {
        XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
        XCTAssertEqual(HTTPMethod.post.rawValue, "POST")
        XCTAssertEqual(HTTPMethod.put.rawValue, "PUT")
        XCTAssertEqual(HTTPMethod.delete.rawValue, "DELETE")
        XCTAssertEqual(HTTPMethod.patch.rawValue, "PATCH")
    }
    
    func testHTTPMethodCases() {
        let allMethods: [HTTPMethod] = [.get, .post, .put, .delete, .patch]
        XCTAssertEqual(allMethods.count, 5)
    }
    
    func testHTTPMethodEquality() {
        XCTAssertEqual(HTTPMethod.get, HTTPMethod.get)
        XCTAssertNotEqual(HTTPMethod.get, HTTPMethod.post)
    }
}
