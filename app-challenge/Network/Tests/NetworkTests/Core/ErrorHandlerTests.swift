import XCTest
@testable import Network

final class ErrorHandlerTests: XCTestCase {
    
    func testHandleTimedOutError() {
        let urlError = URLError(.timedOut)
        let result = ErrorHandler.handleURLError(urlError)
        
        if case RequestError.timeout = result {
        } else {
            XCTFail("Expected RequestError.timeout")
        }
    }
    
    func testHandleCancelledError() {
        let urlError = URLError(.cancelled)
        let result = ErrorHandler.handleURLError(urlError)
        
        if case RequestError.cancelled = result {
        } else {
            XCTFail("Expected RequestError.cancelled")
        }
    }
    
    func testHandleNetworkConnectionLostError() {
        let urlError = URLError(.networkConnectionLost)
        let result = ErrorHandler.handleURLError(urlError)
        
        if case RequestError.networkError(let message) = result {
            XCTAssertTrue(message.contains("Network connection lost"))
            XCTAssertTrue(message.contains("-1005"))
        } else {
            XCTFail("Expected RequestError.networkError with connection lost message")
        }
    }
    
    func testHandleNotConnectedToInternetError() {
        let urlError = URLError(.notConnectedToInternet)
        let result = ErrorHandler.handleURLError(urlError)
        
        if case RequestError.networkError(let message) = result {
            XCTAssertEqual(message, "No internet connection")
        } else {
            XCTFail("Expected RequestError.networkError with no internet message")
        }
    }
    
    func testHandleCannotConnectToHostError() {
        let urlError = URLError(.cannotConnectToHost)
        let result = ErrorHandler.handleURLError(urlError)
        
        if case RequestError.networkError(let message) = result {
            XCTAssertEqual(message, "Unable to connect to server")
        } else {
            XCTFail("Expected RequestError.networkError with cannot connect message")
        }
    }
    
    func testHandleCannotFindHostError() {
        let urlError = URLError(.cannotFindHost)
        let result = ErrorHandler.handleURLError(urlError)
        
        if case RequestError.networkError(let message) = result {
            XCTAssertEqual(message, "Server not found")
        } else {
            XCTFail("Expected RequestError.networkError with server not found message")
        }
    }
    
    func testHandleDNSLookupFailedError() {
        let urlError = URLError(.dnsLookupFailed)
        let result = ErrorHandler.handleURLError(urlError)
        
        if case RequestError.networkError(let message) = result {
            XCTAssertEqual(message, "DNS resolution failed")
        } else {
            XCTFail("Expected RequestError.networkError with DNS failed message")
        }
    }
    
    func testHandleCannotLoadFromNetworkError() {
        let urlError = URLError(.cannotLoadFromNetwork)
        let result = ErrorHandler.handleURLError(urlError)
        
        if case RequestError.networkError(let message) = result {
            XCTAssertEqual(message, "Error loading data from network")
        } else {
            XCTFail("Expected RequestError.networkError with cannot load message")
        }
    }
    
    func testHandleUnknownError() {
        let urlError = URLError(.unknown)
        let result = ErrorHandler.handleURLError(urlError)
        
        if case RequestError.networkError(let message) = result {
            XCTAssertTrue(message.contains("Network error:"))
            XCTAssertTrue(message.contains("Code: -1"))
        } else {
            XCTFail("Expected RequestError.networkError with unknown error message")
        }
    }
    
    func testHandleErrorWithCustomDescription() {
        let urlError = URLError(.badURL)
        let result = ErrorHandler.handleURLError(urlError)
        
        if case RequestError.networkError(let message) = result {
            XCTAssertTrue(message.contains("Network error:"))
            XCTAssertTrue(message.contains("Code: -1000"))
        } else {
            XCTFail("Expected RequestError.networkError with bad URL message")
        }
    }
}
