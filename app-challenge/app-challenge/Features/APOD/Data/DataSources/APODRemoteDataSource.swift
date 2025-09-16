import Foundation
import Network

final class APODRemoteDataSource: APODDataSourceProtocol {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }

    func fetchAPOD(date: String) async throws -> APODResponse {
        return try await requestManager.request(
            endpoint: APODEndpoint.apodByDate(date: date)
        )
    }
    
    func fetchRandomAPOD(count: Int) async throws -> [APODResponse] {
        return try await requestManager.request(
            endpoint: APODEndpoint.apodRandom(count: count)
        )
    }
}
