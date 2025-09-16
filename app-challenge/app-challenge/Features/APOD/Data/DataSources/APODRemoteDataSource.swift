import Foundation

final class APODRemoteDataSource: APODDataSourceProtocol {
    private let service: APODServiceProtocol
    
    init(service: APODServiceProtocol) {
        self.service = service
    }
    
    func fetchAPOD(date: String) async throws -> APODResponse {
        return try await service.fetchAPOD(date: date)
    }
    
    func fetchRandomAPOD(count: Int) async throws -> [APODResponse] {
        return try await service.fetchRandomAPOD(count: count)
    }
}
