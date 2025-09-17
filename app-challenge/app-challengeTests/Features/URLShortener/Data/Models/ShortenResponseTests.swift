import XCTest
@testable import app_challenge

final class ShortenResponseTests: XCTestCase {
    
    func testShortenResponseDecoding() throws {
        let json = """
        {
            "alias": "abc123",
            "_links": {
                "self": "https://api.example.com/abc123",
                "short": "https://short.ly/abc123"
            }
        }
        """
        
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ShortenResponse.self, from: data)
        
        XCTAssertEqual(response.alias, "abc123")
        XCTAssertEqual(response._links.self_.absoluteString, "https://api.example.com/abc123")
        XCTAssertEqual(response._links.short.absoluteString, "https://short.ly/abc123")
    }
    
    func testShortenResponseEncoding() throws {
        let response = ShortenResponse(
            alias: "test123",
            _links: ShortenResponse.Links(
                self_: URL(string: "https://api.example.com/test123")!,
                short: URL(string: "https://short.ly/test123")!
            )
        )
        
        let data = try JSONEncoder().encode(response)
        let decodedResponse = try JSONDecoder().decode(ShortenResponse.self, from: data)
        
        XCTAssertEqual(decodedResponse.alias, response.alias)
        XCTAssertEqual(decodedResponse._links.self_, response._links.self_)
        XCTAssertEqual(decodedResponse._links.short, response._links.short)
    }
    
    func testLinksDecoding() throws {
        let json = """
        {
            "self": "https://api.example.com/abc123",
            "short": "https://short.ly/abc123"
        }
        """
        
        let data = json.data(using: .utf8)!
        let links = try JSONDecoder().decode(ShortenResponse.Links.self, from: data)
        
        XCTAssertEqual(links.self_.absoluteString, "https://api.example.com/abc123")
        XCTAssertEqual(links.short.absoluteString, "https://short.ly/abc123")
    }
}