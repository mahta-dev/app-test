import Foundation

protocol APODDataSourceProtocol {
    func fetchAPOD(date: String) async throws -> APODResponse
    func fetchRandomAPOD(count: Int) async throws -> [APODResponse]
}
