import Foundation

public protocol RequestManagerProtocol: Sendable {
    func request<T: Decodable>(endpoint: EndPointType) async throws -> T
}
