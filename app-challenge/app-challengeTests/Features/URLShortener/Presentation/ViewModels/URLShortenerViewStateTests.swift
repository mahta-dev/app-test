import XCTest
@testable import app_challenge

final class URLShortenerViewStateTests: XCTestCase {
    
    func testIdleState() {
        let state = URLShortenerViewState.idle
        
        XCTAssertFalse(state.isLoading)
        XCTAssertTrue(state.shortenedURLs.isEmpty)
        XCTAssertNil(state.error)
        XCTAssertTrue(state.isEmpty)
    }
    
    func testLoadingState() {
        let state = URLShortenerViewState.loading
        
        XCTAssertTrue(state.isLoading)
        XCTAssertTrue(state.shortenedURLs.isEmpty)
        XCTAssertNil(state.error)
        XCTAssertFalse(state.isEmpty)
    }
    
    func testSuccessState() {
        let urls = [
            ShortenedURLEntity(
                id: "1",
                originalURL: "https://example1.com",
                shortURL: "https://short.ly/1",
                alias: "1",
                createdAt: Date()
            ),
            ShortenedURLEntity(
                id: "2",
                originalURL: "https://example2.com",
                shortURL: "https://short.ly/2",
                alias: "2",
                createdAt: Date()
            )
        ]
        let state = URLShortenerViewState.success(urls)
        
        XCTAssertFalse(state.isLoading)
        XCTAssertEqual(state.shortenedURLs.count, 2)
        XCTAssertEqual(state.shortenedURLs.first?.id, "1")
        XCTAssertEqual(state.shortenedURLs.last?.id, "2")
        XCTAssertNil(state.error)
        XCTAssertFalse(state.isEmpty)
    }
    
    func testErrorState() {
        let error = URLShortenerErrorModel(
            title: "Network Error",
            message: "Failed to connect",
            retryAction: nil
        )
        let state = URLShortenerViewState.error(error)
        
        XCTAssertFalse(state.isLoading)
        XCTAssertTrue(state.shortenedURLs.isEmpty)
        XCTAssertNotNil(state.error)
        XCTAssertEqual(state.error?.title, "Network Error")
        XCTAssertEqual(state.error?.message, "Failed to connect")
        XCTAssertFalse(state.isEmpty)
    }
    
    func testStateEquality() {
        let state1 = URLShortenerViewState.idle
        let state2 = URLShortenerViewState.idle
        let state3 = URLShortenerViewState.loading
        
        XCTAssertEqual(state1, state2)
        XCTAssertNotEqual(state1, state3)
    }
    
    func testSuccessStateEquality() {
        let urls1 = [
            ShortenedURLEntity(
                id: "1",
                originalURL: "https://example.com",
                shortURL: "https://short.ly/1",
                alias: "1",
                createdAt: Date()
            )
        ]
        let urls2 = [
            ShortenedURLEntity(
                id: "1",
                originalURL: "https://example.com",
                shortURL: "https://short.ly/1",
                alias: "1",
                createdAt: Date()
            )
        ]
        
        let state1 = URLShortenerViewState.success(urls1)
        let state2 = URLShortenerViewState.success(urls2)
        
        XCTAssertEqual(state1, state2)
    }
}

final class URLShortenerErrorModelTests: XCTestCase {
    
    func testDefaultInitialization() {
        let error = URLShortenerErrorModel(message: "Test error")
        
        XCTAssertEqual(error.title, "Error")
        XCTAssertEqual(error.message, "Test error")
        XCTAssertNil(error.retryAction)
    }
    
    func testCustomInitialization() {
        let retryAction = {}
        let error = URLShortenerErrorModel(
            title: "Custom Error",
            message: "Custom message",
            retryAction: retryAction
        )
        
        XCTAssertEqual(error.title, "Custom Error")
        XCTAssertEqual(error.message, "Custom message")
        XCTAssertNotNil(error.retryAction)
    }
    
    func testEquality() {
        let error1 = URLShortenerErrorModel(
            title: "Error",
            message: "Test message"
        )
        let error2 = URLShortenerErrorModel(
            title: "Error",
            message: "Test message"
        )
        let error3 = URLShortenerErrorModel(
            title: "Different",
            message: "Test message"
        )
        
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }
}