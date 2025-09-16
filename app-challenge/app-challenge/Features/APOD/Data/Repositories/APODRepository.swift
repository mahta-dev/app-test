import Foundation

final class APODRepository: APODRepositoryProtocol {
    private let dataSource: APODDataSourceProtocol
    
    init(dataSource: APODDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchAPOD(date: String) async throws -> APODResponse {
        return try await dataSource.fetchAPOD(date: date)
    }
    
    func fetchRandomAPOD(count: Int) async throws -> [APODResponse] {
        return try await dataSource.fetchRandomAPOD(count: count)
    }
}
