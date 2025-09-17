import Foundation

public struct MockResponse: Codable, Equatable {
    public let id: Int
    public let name: String
    public let isActive: Bool
    
    public init(id: Int = 1, name: String = "Test", isActive: Bool = true) {
        self.id = id
        self.name = name
        self.isActive = isActive
    }
}

public struct MockErrorResponse: Codable {
    public let error: String
    public let code: Int
    
    public init(error: String = "Test Error", code: Int = 400) {
        self.error = error
        self.code = code
    }
}
