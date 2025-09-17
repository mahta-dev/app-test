import XCTest
@testable import app_challenge
import Combine

@MainActor
final class URLShortenerViewModelTests: XCTestCase {
    
    var viewModel: URLShortenerViewModel!
    var mockUseCase: MockURLShortenerUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockUseCase = MockURLShortenerUseCase()
        viewModel = URLShortenerViewModel(useCase: mockUseCase)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        viewModel = nil
        mockUseCase = nil
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertEqual(viewModel.inputText, "")
    }
    
    func testShortenURL_Success() async {
        let url = "https://example.com"
        let expectedEntity = ShortenedURLEntity(
            id: "test-id",
            originalURL: url,
            shortURL: "https://short.ly/test",
            alias: "test",
            createdAt: Date()
        )
        mockUseCase.shortenURLResult = .success(expectedEntity)
        
        viewModel.inputText = url
        viewModel.handle(.shortenURL(url))
        
        await Task.yield()
        
        XCTAssertEqual(viewModel.state.shortenedURLs.count, 1)
        XCTAssertEqual(viewModel.state.shortenedURLs.first?.id, "test-id")
        XCTAssertTrue(mockUseCase.shortenURLCalled)
    }
    
    func testShortenURL_Error() async {
        let url = "https://example.com"
        mockUseCase.shortenURLResult = .failure(TestError.networkError)
        
        viewModel.inputText = url
        viewModel.handle(.shortenURL(url))
        
        await Task.yield()
        
        XCTAssertNotNil(viewModel.state.error)
        XCTAssertTrue(mockUseCase.shortenURLCalled)
    }
    
    func testLoadShortenedURLs_Success() async {
        let urls = [
            ShortenedURLEntity(
                id: "1",
                originalURL: "https://example1.com",
                shortURL: "https://short.ly/1",
                alias: "1",
                createdAt: Date()
            )
        ]
        mockUseCase.getShortenedURLsResult = .success(urls)
        
        viewModel.handle(.loadShortenedURLs)
        
        await Task.yield()
        
        XCTAssertEqual(viewModel.state.shortenedURLs.count, 1)
        XCTAssertTrue(mockUseCase.getShortenedURLsCalled)
    }
    
    func testLoadShortenedURLs_Error() async {
        mockUseCase.getShortenedURLsResult = .failure(TestError.networkError)
        
        viewModel.handle(.loadShortenedURLs)
        
        await Task.yield()
        
        XCTAssertNotNil(viewModel.state.error)
        XCTAssertTrue(mockUseCase.getShortenedURLsCalled)
    }
    
    func testDeleteURL_Success() async {
        mockUseCase.deleteURLResult = .success(())
        
        viewModel.handle(.deleteURL("test-id"))
        
        await Task.yield()
        
        XCTAssertTrue(mockUseCase.deleteURLCalled)
        XCTAssertEqual(mockUseCase.lastDeleteURLId, "test-id")
    }
    
    func testDeleteURL_Error() async {
        mockUseCase.deleteURLResult = .failure(TestError.deleteError)
        
        viewModel.handle(.deleteURL("test-id"))
        
        await Task.yield()
        
        XCTAssertNotNil(viewModel.state.error)
        XCTAssertTrue(mockUseCase.deleteURLCalled)
    }
    
    func testClearError() {
        let error = URLShortenerErrorModel(message: "Test error")
        viewModel.state = .error(error)
        
        viewModel.handle(.clearError)
        
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    func testRefresh() async {
        let urls = [
            ShortenedURLEntity(
                id: "1",
                originalURL: "https://example.com",
                shortURL: "https://short.ly/1",
                alias: "1",
                createdAt: Date()
            )
        ]
        mockUseCase.getShortenedURLsResult = .success(urls)
        
        viewModel.handle(.refresh)
        
        await Task.yield()
        
        XCTAssertEqual(viewModel.state.shortenedURLs.count, 1)
        XCTAssertTrue(mockUseCase.getShortenedURLsCalled)
    }
    
    func testInputTextBinding() {
        let newText = "https://newurl.com"
        viewModel.inputText = newText
        
        XCTAssertEqual(viewModel.inputText, newText)
    }
    
}
