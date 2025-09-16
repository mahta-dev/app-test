import Foundation
import Network

protocol APODServiceProtocol {
    func fetchAPOD(date: String) async throws -> APODResponse
    func request<T: Decodable>(endpoint: EndPointType) async throws -> T
}

final class APODService: APODServiceProtocol, Sendable {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }

    func fetchAPOD(date: String) async throws -> APODResponse {
        return try await requestManager.request(
            endpoint: APIEndpoint.apodByDate(date: date)
        )
    }
    
    func request<T: Decodable>(endpoint: EndPointType) async throws -> T {
        return try await requestManager.request(endpoint: endpoint)
    }
}
