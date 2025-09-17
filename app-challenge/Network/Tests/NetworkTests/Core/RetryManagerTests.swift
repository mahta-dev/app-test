import XCTest
@testable import Network

final class RetryManagerTests: XCTestCase {
    
    var retryManager: RetryManager!
    
    override func setUp() {
        super.setUp()
        retryManager = RetryManager(retryCount: 3, retryDelay: 0.1)
    }
    
    override func tearDown() {
        retryManager = nil
        super.tearDown()
    }
    
    func testExecuteWithRetrySuccessOnFirstAttempt() async throws {
        var attemptCount = 0
        
        let result = try await retryManager.executeWithRetry {
            attemptCount += 1
            return "Success"
        }
        
        XCTAssertEqual(result, "Success")
        XCTAssertEqual(attemptCount, 1)
    }
    
    func testExecuteWithRetrySuccessOnSecondAttempt() async throws {
        var attemptCount = 0
        
        let result = try await retryManager.executeWithRetry {
            attemptCount += 1
            if attemptCount == 1 {
                throw URLError(.networkConnectionLost)
            }
            return "Success"
        }
        
        XCTAssertEqual(result, "Success")
        XCTAssertEqual(attemptCount, 2)
    }
    
    func testExecuteWithRetrySuccessOnThirdAttempt() async throws {
        var attemptCount = 0
        
        let result = try await retryManager.executeWithRetry {
            attemptCount += 1
            if attemptCount <= 2 {
                throw URLError(.networkConnectionLost)
            }
            return "Success"
        }
        
        XCTAssertEqual(result, "Success")
        XCTAssertEqual(attemptCount, 3)
    }
    
    
    func testExecuteWithRetryNonRetryableError() async {
        var attemptCount = 0
        
        do {
            let _ = try await retryManager.executeWithRetry {
                attemptCount += 1
                throw URLError(.badURL)
            }
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.networkError(let message) = error {
                XCTAssertTrue(message.contains("Network error:"))
            } else {
                XCTFail("Expected RequestError.networkError")
            }
        }
        
        XCTAssertEqual(attemptCount, 1)
    }
    
    func testExecuteWithRetryRequestError() async {
        var attemptCount = 0
        
        do {
            let _ = try await retryManager.executeWithRetry {
                attemptCount += 1
                throw RequestError.invalidURL
            }
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.invalidURL = error {
            } else {
                XCTFail("Expected RequestError.invalidURL")
            }
        }
        
        XCTAssertEqual(attemptCount, 1)
    }
    
    func testExecuteWithRetryHTTPError500() async {
        var attemptCount = 0
        
        do {
            let _ = try await retryManager.executeWithRetry {
                attemptCount += 1
                throw RequestError.httpError(statusCode: 500, message: "Server Error", data: nil)
            }
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.httpError(let statusCode, _, _) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Expected RequestError.httpError with status 500")
            }
        }
        
        XCTAssertEqual(attemptCount, 4)
    }
    
    func testExecuteWithRetryHTTPError400() async {
        var attemptCount = 0
        
        do {
            let _ = try await retryManager.executeWithRetry {
                attemptCount += 1
                throw RequestError.httpError(statusCode: 400, message: "Bad Request", data: nil)
            }
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.httpError(let statusCode, _, _) = error {
                XCTAssertEqual(statusCode, 400)
            } else {
                XCTFail("Expected RequestError.httpError with status 400")
            }
        }
        
        XCTAssertEqual(attemptCount, 1)
    }
    
    func testExecuteWithRetryDecodingError() async {
        var attemptCount = 0
        
        do {
            let _ = try await retryManager.executeWithRetry {
                attemptCount += 1
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Test"))
            }
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
        
        XCTAssertEqual(attemptCount, 1)
    }
    
    func testExecuteWithRetryCustomRetryCount() async throws {
        let customRetryManager = RetryManager(retryCount: 1, retryDelay: 0.1)
        var attemptCount = 0
        
        let result = try await customRetryManager.executeWithRetry {
            attemptCount += 1
            if attemptCount == 1 {
                throw URLError(.networkConnectionLost)
            }
            return "Success"
        }
        
        XCTAssertEqual(result, "Success")
        XCTAssertEqual(attemptCount, 2)
    }
}
