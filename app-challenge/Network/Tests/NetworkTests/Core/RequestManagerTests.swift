import XCTest
@testable import Network

final class RequestManagerTests: XCTestCase {
    
    var mockSession: MockURLSession!
    var requestManager: RequestManager!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        requestManager = RequestManager(
            baseURL: "https://test.example.com",
            session: mockSession,
            retryCount: 2,
            retryDelay: 0.1
        )
    }
    
    override func tearDown() {
        mockSession = nil
        requestManager = nil
        super.tearDown()
    }
    
    func testRequestSuccess() async throws {
        let mockResponse = MockResponse(id: 456, name: "Test Success")
        let responseData = try JSONEncoder().encode(mockResponse)
        mockSession.setSuccessResponse(data: responseData, statusCode: 200)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        let result: MockResponse = try await requestManager.request(endpoint: endpoint)
        
        XCTAssertEqual(result.id, 456)
        XCTAssertEqual(result.name, "Test Success")
        XCTAssertEqual(result.isActive, true)
        
        XCTAssertEqual(mockSession.capturedRequests.count, 1)
        let request = mockSession.capturedRequests.first!
        XCTAssertEqual(request.url?.absoluteString, "https://test.example.com/api/test")
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testRequestWithHeaders() async throws {
        let mockResponse = MockResponse()
        let responseData = try JSONEncoder().encode(mockResponse)
        mockSession.setSuccessResponse(data: responseData, statusCode: 200)
        
        let endpoint = MockEndpoint(
            path: "/api/test",
            headers: ["Authorization": "Bearer token", "Content-Type": "application/json"]
        )
        
        let _: MockResponse = try await requestManager.request(endpoint: endpoint)
        
        let request = mockSession.capturedRequests.first!
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer token")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func testRequestWithBody() async throws {
        let mockResponse = MockResponse()
        let responseData = try JSONEncoder().encode(mockResponse)
        mockSession.setSuccessResponse(data: responseData, statusCode: 200)
        
        let requestBody = try JSONEncoder().encode(MockResponse(id: 999, name: "Request Body"))
        let endpoint = MockEndpoint(
            path: "/api/test",
            httpMethod: .post,
            body: requestBody
        )
        
        let _: MockResponse = try await requestManager.request(endpoint: endpoint)
        
        let request = mockSession.capturedRequests.first!
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.httpBody, requestBody)
    }
    
    func testRequestWithQueryParameters() async throws {
        let mockResponse = MockResponse()
        let responseData = try JSONEncoder().encode(mockResponse)
        mockSession.setSuccessResponse(data: responseData, statusCode: 200)
        
        let endpoint = MockEndpoint(
            path: "/api/search",
            queryParameters: ["q": "test query", "page": 2, "active": true]
        )
        
        let _: MockResponse = try await requestManager.request(endpoint: endpoint)
        
        let request = mockSession.capturedRequests.first!
        XCTAssertTrue(request.url?.absoluteString.contains("q=test%20query") == true)
        XCTAssertTrue(request.url?.absoluteString.contains("page=2") == true)
        XCTAssertTrue(request.url?.absoluteString.contains("active=true") == true)
    }
    
    func testRequestWithHTTPError() async {
        let errorData = try! JSONEncoder().encode(MockErrorResponse(error: "Not Found", code: 404))
        mockSession.setSuccessResponse(data: errorData, statusCode: 404)
        
        let endpoint = MockEndpoint(path: "/api/notfound")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
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
    
    func testRequestWithNetworkError() async {
        mockSession.setURLError(.networkConnectionLost)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.networkError(let message) = error {
                XCTAssertTrue(message.contains("Network connection lost"))
            } else {
                XCTFail("Expected RequestError.networkError")
            }
        }
    }
    
    func testRequestWithDecodingError() async {
        let invalidJSON = Data("invalid json".utf8)
        mockSession.setSuccessResponse(data: invalidJSON, statusCode: 200)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown a decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testRequestWithRetrySuccess() async throws {
        var attemptCount = 0
        let mockResponse = MockResponse(id: 789, name: "Retry Success")
        let responseData = try JSONEncoder().encode(mockResponse)
        
        mockSession.dataResult = .failure(URLError(.networkConnectionLost))
        
        let retrySession = MockURLSession()
        retrySession.dataResult = .failure(URLError(.networkConnectionLost))
        
        let retryRequestManager = RequestManager(
            baseURL: "https://test.example.com",
            session: retrySession,
            retryCount: 2,
            retryDelay: 0.1
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            retrySession.setSuccessResponse(data: responseData, statusCode: 200)
        }
        
        let endpoint = MockEndpoint(path: "/api/retry")
        
        do {
            let result: MockResponse = try await retryRequestManager.request(endpoint: endpoint)
            XCTAssertEqual(result.id, 789)
        } catch {
            XCTAssertTrue(error is RequestError)
        }
    }
    
    func testRequestWithCustomBaseURL() async throws {
        let customRequestManager = RequestManager(
            baseURL: "https://custom.api.com",
            session: mockSession,
            retryCount: 1,
            retryDelay: 0.1
        )
        
        let mockResponse = MockResponse()
        let responseData = try JSONEncoder().encode(mockResponse)
        mockSession.setSuccessResponse(data: responseData, statusCode: 200)
        
        let endpoint = MockEndpoint(path: "/v1/data")
        
        let _: MockResponse = try await customRequestManager.request(endpoint: endpoint)
        
        let request = mockSession.capturedRequests.first!
        XCTAssertEqual(request.url?.absoluteString, "https://custom.api.com/v1/data")
    }
    
    func testRequestWithAllHTTPMethods() async throws {
        let mockResponse = MockResponse()
        let responseData = try JSONEncoder().encode(mockResponse)
        
        let methods: [HTTPMethod] = [.get, .post, .put, .delete, .patch]
        
        for method in methods {
            mockSession.setSuccessResponse(data: responseData, statusCode: 200)
            
            let endpoint = MockEndpoint(
                path: "/api/test",
                httpMethod: method
            )
            
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            
            let request = mockSession.capturedRequests.last!
            XCTAssertEqual(request.httpMethod, method.rawValue)
        }
    }
    
    func testRequestWithURLErrorTimedOut() async {
        mockSession.setURLError(.timedOut)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.timeout = error {
            } else {
                XCTFail("Expected RequestError.timeout")
            }
        }
    }
    
    func testRequestWithURLErrorCancelled() async {
        mockSession.setURLError(.cancelled)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.cancelled = error {
            } else {
                XCTFail("Expected RequestError.cancelled")
            }
        }
    }
    
    func testRequestWithURLErrorNotConnectedToInternet() async {
        mockSession.setURLError(.notConnectedToInternet)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.networkError(let message) = error {
                XCTAssertEqual(message, "No internet connection")
            } else {
                XCTFail("Expected RequestError.networkError with no internet message")
            }
        }
    }
    
    func testRequestWithURLErrorCannotConnectToHost() async {
        mockSession.setURLError(.cannotConnectToHost)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.networkError(let message) = error {
                XCTAssertEqual(message, "Unable to connect to server")
            } else {
                XCTFail("Expected RequestError.networkError with cannot connect message")
            }
        }
    }
    
    func testRequestWithURLErrorCannotFindHost() async {
        mockSession.setURLError(.cannotFindHost)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.networkError(let message) = error {
                XCTAssertEqual(message, "Server not found")
            } else {
                XCTFail("Expected RequestError.networkError with server not found message")
            }
        }
    }
    
    func testRequestWithURLErrorDNSLookupFailed() async {
        mockSession.setURLError(.dnsLookupFailed)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.networkError(let message) = error {
                XCTAssertEqual(message, "DNS resolution failed")
            } else {
                XCTFail("Expected RequestError.networkError with DNS failed message")
            }
        }
    }
    
    func testRequestWithURLErrorCannotLoadFromNetwork() async {
        mockSession.setURLError(.cannotLoadFromNetwork)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.networkError(let message) = error {
                XCTAssertEqual(message, "Error loading data from network")
            } else {
                XCTFail("Expected RequestError.networkError with cannot load message")
            }
        }
    }
    
    func testRequestWithURLErrorUnknown() async {
        mockSession.setURLError(.unknown)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.networkError(let message) = error {
                XCTAssertTrue(message.contains("Network error:"))
                XCTAssertTrue(message.contains("Code: -1"))
            } else {
                XCTFail("Expected RequestError.networkError with unknown error message")
            }
        }
    }
    
    func testRequestWithRequestErrorPassthrough() async {
        mockSession.dataResult = .failure(RequestError.invalidURL)
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.invalidURL = error {
            } else {
                XCTFail("Expected RequestError.invalidURL to pass through unchanged")
            }
        }
    }
    
    func testRequestWithDecodingErrorPassthrough() async {
        mockSession.dataResult = .failure(DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Test decoding error")))
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is DecodingError)
            if case DecodingError.dataCorrupted = error {
            } else {
                XCTFail("Expected DecodingError to pass through unchanged")
            }
        }
    }
    
    func testRequestWithGenericError() async {
        mockSession.dataResult = .failure(NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test generic error"]))
        
        let endpoint = MockEndpoint(path: "/api/test")
        
        do {
            let _: MockResponse = try await requestManager.request(endpoint: endpoint)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RequestError)
            if case RequestError.networkError(let message) = error {
                XCTAssertEqual(message, "Test generic error")
            } else {
                XCTFail("Expected RequestError.networkError with generic error message")
            }
        }
    }
}
