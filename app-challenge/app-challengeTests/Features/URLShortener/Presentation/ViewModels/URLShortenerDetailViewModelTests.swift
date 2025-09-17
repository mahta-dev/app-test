import XCTest
@testable import app_challenge
import Combine

@MainActor
final class URLShortenerDetailViewModelTests: XCTestCase {
    
    var viewModel: URLShortenerDetailViewModel!
    var mockUseCase: MockURLShortenerUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockUseCase = MockURLShortenerUseCase()
        viewModel = URLShortenerDetailViewModel(useCase: mockUseCase)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        viewModel = nil
        mockUseCase = nil
    }
    
    func testInitialState() {
        XCTAssertNil(viewModel.resolvedURL)
        XCTAssertFalse(viewModel.isResolving)
        XCTAssertNil(viewModel.resolveError)
    }
    
    func testResolveURL_Success() async {
        let alias = "abc123"
        let expectedURL = "https://example.com"
        mockUseCase.resolveURLResult = .success(expectedURL)
        
        viewModel.handle(.resolveURL(alias))
        
        await Task.yield()
        
        XCTAssertEqual(viewModel.resolvedURL, expectedURL)
        XCTAssertFalse(viewModel.isResolving)
        XCTAssertNil(viewModel.resolveError)
        XCTAssertTrue(mockUseCase.resolveURLCalled)
        XCTAssertEqual(mockUseCase.lastResolveURLAlias, alias)
    }
    
    func testResolveURL_Error() async {
        let alias = "invalid"
        mockUseCase.resolveURLResult = .failure(TestError.notFound)
        
        viewModel.handle(.resolveURL(alias))
        
        await Task.yield()
        
        XCTAssertNil(viewModel.resolvedURL)
        XCTAssertFalse(viewModel.isResolving)
        XCTAssertNotNil(viewModel.resolveError)
        XCTAssertTrue(mockUseCase.resolveURLCalled)
        XCTAssertEqual(mockUseCase.lastResolveURLAlias, alias)
    }
    
    func testClearError() {
        viewModel.resolveError = "Test error"
        
        viewModel.handle(.clearError)
        
        XCTAssertNil(viewModel.resolveError)
    }
    
    func testIsResolvingState() async {
        let alias = "abc123"
        mockUseCase.resolveURLResult = .success("https://example.com")
        
        let expectation = XCTestExpectation(description: "Resolve URL")
        
        Task {
            viewModel.handle(.resolveURL(alias))
            expectation.fulfill()
        }
        
        XCTAssertTrue(viewModel.isResolving)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertFalse(viewModel.isResolving)
    }
    
    func testViewModelProtocolConformance() {
        XCTAssertTrue(viewModel is URLShortenerDetailViewModelProtocol)
    }
    
    func testMultipleResolveCalls() async {
        let alias1 = "abc123"
        let alias2 = "def456"
        let url1 = "https://example1.com"
        let url2 = "https://example2.com"
        
        mockUseCase.resolveURLResult = .success(url1)
        viewModel.handle(.resolveURL(alias1))
        
        await Task.yield()
        
        XCTAssertEqual(viewModel.resolvedURL, url1)
        XCTAssertEqual(mockUseCase.resolveURLCallCount, 1)
        
        mockUseCase.resolveURLResult = .success(url2)
        viewModel.handle(.resolveURL(alias2))
        
        await Task.yield()
        
        XCTAssertEqual(viewModel.resolvedURL, url2)
        XCTAssertEqual(mockUseCase.resolveURLCallCount, 2)
    }
}
