import XCTest
@testable import app_challenge

final class StringValidationTests: XCTestCase {
    
    func testValidURLs() {
        let validURLs = [
            "https://www.google.com",
            "http://example.com",
            "https://subdomain.example.com/path?query=value",
            "https://example.com:8080/path",
            "https://example.com/path#fragment"
        ]
        
        for urlString in validURLs {
            XCTAssertTrue(urlString.isValidURL, "URL should be valid: \(urlString)")
        }
    }
    
    func testInvalidURLs() {
        let invalidURLs = [
            "not-a-url",
            "ftp://example.com",
            "javascript:alert('xss')",
            "data:text/html,<script>alert('xss')</script>",
            "file:///etc/passwd",
            "",
            "   ",
            "https://",
            "http://",
            "://example.com"
        ]
        
        for urlString in invalidURLs {
            XCTAssertFalse(urlString.isValidURL, "URL should be invalid: \(urlString)")
        }
    }
    
    func testValidAliases() {
        let validAliases = [
            "abc123",
            "test",
            "my-alias",
            "alias_123",
            "a",
            "1234567890"
        ]
        
        for alias in validAliases {
            XCTAssertTrue(alias.isValidAlias, "Alias should be valid: \(alias)")
        }
    }
    
    func testInvalidAliases() {
        let invalidAliases = [
            "",
            "   ",
            "abc-123!",
            "alias with spaces",
            "alias@domain",
            "alias#hash",
            "alias$dollar",
            "alias%percent",
            "alias^caret",
            "alias&ampersand",
            "alias*asterisk",
            "alias(open",
            "alias)close",
            "alias+plus",
            "alias=equals",
            "alias[open",
            "alias]close",
            "alias{open",
            "alias}close",
            "alias|pipe",
            "alias\\backslash",
            "alias:colon",
            "alias;semcolon",
            "alias\"quote",
            "alias'apostrophe",
            "alias<less",
            "alias>greater",
            "alias,comma",
            "alias.question",
            "alias/slash"
        ]
        
        for alias in invalidAliases {
            XCTAssertFalse(alias.isValidAlias, "Alias should be invalid: \(alias)")
        }
    }
    
    func testEdgeCases() {
        XCTAssertFalse("".isValidURL)
        XCTAssertFalse("".isValidAlias)
        XCTAssertFalse("   ".isValidURL)
        XCTAssertFalse("   ".isValidAlias)
        
        let veryLongURL = "https://example.com/" + String(repeating: "a", count: 3000)
        XCTAssertTrue(veryLongURL.isValidURL)
        
        let veryLongAlias = String(repeating: "a", count: 100)
        XCTAssertTrue(veryLongAlias.isValidAlias)
    }
}