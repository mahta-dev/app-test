import XCTest
@testable import Network

final class SafeDictionaryTests: XCTestCase {
    
    func testSafeDictionaryFromValidData() {
        let jsonData = """
        {
            "name": "Test",
            "age": 25,
            "active": true,
            "scores": [1, 2, 3]
        }
        """.data(using: .utf8)!
        
        let dictionary = SafeDictionary.from(data: jsonData)
        
        XCTAssertNotNil(dictionary)

    }
    
    
    func testSafeDictionaryEquality() {
        let jsonData1 = """
        {
            "name": "Test",
            "age": 25
        }
        """.data(using: .utf8)!
        
        let jsonData2 = """
        {
            "name": "Test",
            "age": 25
        }
        """.data(using: .utf8)!
        
        let dictionary1 = SafeDictionary.from(data: jsonData1)
        let dictionary2 = SafeDictionary.from(data: jsonData2)
        
        XCTAssertEqual(dictionary1, dictionary2)
    }
    
    func testSafeDictionaryInequality() {
        let jsonData1 = """
        {
            "name": "Test",
            "age": 25
        }
        """.data(using: .utf8)!
        
        let jsonData2 = """
        {
            "name": "Test",
            "age": 30
        }
        """.data(using: .utf8)!
        
        let dictionary1 = SafeDictionary.from(data: jsonData1)
        let dictionary2 = SafeDictionary.from(data: jsonData2)
        
        XCTAssertNotEqual(dictionary1, dictionary2)
    }
  
    
}
