import XCTest
@testable import Network

final class RequestErrorTests: XCTestCase {
    
    func testRequestErrorCases() {
        let timeoutError = RequestError.timeout
        let cancelledError = RequestError.cancelled
        let invalidURLError = RequestError.invalidURL
        let invalidResponseError = RequestError.invalidResponse
        let networkError = RequestError.networkError("Test error")
        let httpError = RequestError.httpError(statusCode: 404, message: "Not Found", data: nil)
        
        XCTAssertNotNil(timeoutError)
        XCTAssertNotNil(cancelledError)
        XCTAssertNotNil(invalidURLError)
        XCTAssertNotNil(invalidResponseError)
        XCTAssertNotNil(networkError)
        XCTAssertNotNil(httpError)
    }
    
    func testNetworkErrorWithMessage() {
        let errorMessage = "Custom network error"
        let error = RequestError.networkError(errorMessage)
        
        if case RequestError.networkError(let message) = error {
            XCTAssertEqual(message, errorMessage)
        } else {
            XCTFail("Expected RequestError.networkError")
        }
    }
    
    func testHTTPErrorWithDetails() {
        let statusCode = 500
        let message = "Internal Server Error"
        let jsonData = """
        {
            "error": "Server is down"
        }
        """.data(using: .utf8)!
        let data = SafeDictionary.from(data: jsonData)
        
        let error = RequestError.httpError(statusCode: statusCode, message: message, data: data)
        
        if case RequestError.httpError(let code, let errorMessage, let errorData) = error {
            XCTAssertEqual(code, statusCode)
            XCTAssertEqual(errorMessage, message)
            XCTAssertEqual(errorData, data)
        } else {
            XCTFail("Expected RequestError.httpError")
        }
    }
    
    func testRequestErrorEquality() {
        let error1 = RequestError.timeout
        let error2 = RequestError.timeout
        let error3 = RequestError.cancelled
        
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }
    
    func testRequestErrorWithNilData() {
        let error = RequestError.httpError(statusCode: 400, message: "Bad Request", data: nil)
        
        if case RequestError.httpError(let statusCode, let message, let data) = error {
            XCTAssertEqual(statusCode, 400)
            XCTAssertEqual(message, "Bad Request")
            XCTAssertNil(data)
        } else {
            XCTFail("Expected RequestError.httpError")
        }
    }
}
