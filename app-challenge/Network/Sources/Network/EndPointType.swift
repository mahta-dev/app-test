import Foundation

public typealias HTTPHeaders = [String: String]

public protocol EndPointType: Sendable {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryParameters: [String: Any] { get }
    var body: Data? { get }
    var requiresAuth: Bool { get }
}
