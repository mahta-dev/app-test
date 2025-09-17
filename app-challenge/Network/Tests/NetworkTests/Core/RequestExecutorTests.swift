import XCTest
@testable import Network

final class RequestExecutorTests: XCTestCase {
    
    var mockSession: MockURLSession!
    var requestExecutor: RequestExecutor!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        requestExecutor = RequestExecutor(session: mockSession)
    }
    
    override func tearDown() {
        mockSession = nil
        requestExecutor = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() async throws {
        let mockResponse = MockResponse(id: 123, name: "Test Response")
        let responseData = try JSONEncoder().encode(mockResponse)
        mockSession.setSuccessResponse(data: responseData, statusCode: 200)
        
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.httpMethod = "GET"
        
        let result: MockResponse = try await requestExecutor.execute(request: request)
        
        XCTAssertEqual(result.id, 123)
        XCTAssertEqual(result.name, "Test Response")
        XCTAssertEqual(result.isActive, true)
    }
    
    func testExecuteWithInvalidResponse() async {
        let responseData = Data()
        let response = URLResponse(url: URL(string: "https://example.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        mockSession.dataResult = .success((responseData, response))
        
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.httpMethod = "GET"
        
        do {
            let _: MockResponse = try await requestExecutor.execute(request: request)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.invalidResponse = error {
            } else {
                XCTFail("Expected RequestError.invalidResponse")
            }
        }
    }
    
    func testExecuteWithHTTPError() async {
        let errorData = try! JSONEncoder().encode(MockErrorResponse(error: "Not Found", code: 404))
        mockSession.setSuccessResponse(data: errorData, statusCode: 404)
        
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.httpMethod = "GET"
        
        do {
            let _: MockResponse = try await requestExecutor.execute(request: request)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.httpError(let statusCode, _, _) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected RequestError.httpError with status 404")
            }
        }
    }
    
    func testExecuteWithDecodingError() async {
        let invalidJSON = Data("invalid json".utf8)
        mockSession.setSuccessResponse(data: invalidJSON, statusCode: 200)
        
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.httpMethod = "GET"
        
        do {
            let _: MockResponse = try await requestExecutor.execute(request: request)
            XCTFail("Should have thrown a decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testExecuteWithNetworkError() async {
        mockSession.setURLError(.networkConnectionLost)
        
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.httpMethod = "GET"
        
        do {
            let _: MockResponse = try await requestExecutor.execute(request: request)
            XCTFail("Should have thrown a network error")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testExecuteWithSuccessStatusCodeRange() async throws {
        let mockResponse = MockResponse()
        let responseData = try JSONEncoder().encode(mockResponse)
        
        for statusCode in 200...299 {
            mockSession.setSuccessResponse(data: responseData, statusCode: statusCode)
            
            var request = URLRequest(url: URL(string: "https://example.com")!)
            request.httpMethod = "GET"
            
            let result: MockResponse = try await requestExecutor.execute(request: request)
            XCTAssertEqual(result.id, mockResponse.id)
        }
    }
}
