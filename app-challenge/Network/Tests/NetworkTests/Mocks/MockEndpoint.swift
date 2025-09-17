import Foundation
@testable import Network

public struct MockEndpoint: EndPointType {
    public let path: String
    public let httpMethod: HTTPMethod
    public let headers: [String: String]?
    public let queryParameters: [String: Any]
    public let body: Data?
    public let requiresAuth: Bool
    
    public init(
        path: String = "/test",
        httpMethod: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryParameters: [String: Any] = [:],
        body: Data? = nil,
        requiresAuth: Bool = false
    ) {
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = body
        self.requiresAuth = requiresAuth
    }
}
