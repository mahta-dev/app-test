import XCTest
@testable import app_challenge

final class ShortenedURLEntityTests: XCTestCase {
    
    func testInitialization() {
        let id = "test-id"
        let originalURL = "https://example.com"
        let shortURL = "https://short.ly/abc123"
        let alias = "abc123"
        let createdAt = Date()
        
        let entity = ShortenedURLEntity(
            id: id,
            originalURL: originalURL,
            shortURL: shortURL,
            alias: alias,
            createdAt: createdAt
        )
        
        XCTAssertEqual(entity.id, id)
        XCTAssertEqual(entity.originalURL, originalURL)
        XCTAssertEqual(entity.shortURL, shortURL)
        XCTAssertEqual(entity.alias, alias)
        XCTAssertEqual(entity.createdAt, createdAt)
    }
    
    func testEquality() {
        let date = Date()
        let entity1 = ShortenedURLEntity(
            id: "test-id",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123",
            alias: "abc123",
            createdAt: date
        )
        
        let entity2 = ShortenedURLEntity(
            id: "test-id",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123",
            alias: "abc123",
            createdAt: date
        )
        
        XCTAssertEqual(entity1, entity2)
    }
    
    func testInequality() {
        let date = Date()
        let entity1 = ShortenedURLEntity(
            id: "test-id-1",
            originalURL: "https://example1.com",
            shortURL: "https://short.ly/abc123",
            alias: "abc123",
            createdAt: date
        )
        
        let entity2 = ShortenedURLEntity(
            id: "test-id-2",
            originalURL: "https://example2.com",
            shortURL: "https://short.ly/def456",
            alias: "def456",
            createdAt: date
        )
        
        XCTAssertNotEqual(entity1, entity2)
    }
    
    func testHashable() {
        let entity = ShortenedURLEntity(
            id: "test-id",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123",
            alias: "abc123",
            createdAt: Date()
        )
        
        let set: Set<ShortenedURLEntity> = [entity]
        XCTAssertTrue(set.contains(entity))
    }
}