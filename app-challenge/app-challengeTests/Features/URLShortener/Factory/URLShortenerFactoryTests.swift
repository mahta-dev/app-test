import XCTest
@testable import app_challenge
@testable import Network

@MainActor
final class URLShortenerFactoryTests: XCTestCase {
    
    var factory: URLShortenerFactory!
    
    override func setUpWithError() throws {
        factory = URLShortenerFactory()
    }
    
    override func tearDownWithError() throws {
        factory = nil
    }
    
    @MainActor
    func testCreateURLShortenerView() {
        let view = factory.createURLShortenerView()
        
        XCTAssertNotNil(view)
        XCTAssertTrue(view is URLShortenerMainView<URLShortenerViewModel>)
    }
    
    @MainActor
    func testFactoryProtocolConformance() {
        XCTAssertTrue(factory is URLShortenerFactoryProtocol)
    }
}

@MainActor
final class URLShortenerFactoryManagerTests: XCTestCase {
    
    var factoryManager: URLShortenerFactoryManager!
    var mockFactory: MockURLShortenerFactory!
    
    override func setUpWithError() throws {
        mockFactory = MockURLShortenerFactory()
        factoryManager = URLShortenerFactoryManager(factory: mockFactory)
    }
    
    override func tearDownWithError() throws {
        factoryManager = nil
        mockFactory = nil
    }
    
    @MainActor
    func testCreateURLShortenerView() {
        let view = factoryManager.createURLShortenerView()
        
        XCTAssertNotNil(view)
        XCTAssertTrue(mockFactory.createURLShortenerViewCalled)
    }
    
    @MainActor
    func testFactoryManagerProtocolConformance() {
        XCTAssertTrue(factoryManager is URLShortenerFactoryManagerProtocol)
    }
    
    @MainActor
    func testDependencyInjection() {
        let customFactory = MockURLShortenerFactory()
        let manager = URLShortenerFactoryManager(factory: customFactory)
        
        _ = manager.createURLShortenerView()
        
        XCTAssertTrue(customFactory.createURLShortenerViewCalled)
    }
}
