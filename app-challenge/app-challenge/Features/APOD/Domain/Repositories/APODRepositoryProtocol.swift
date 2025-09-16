import Foundation

protocol APODRepositoryProtocol {
    func fetchAPOD(date: String) async throws -> APODResponse
    func fetchRandomAPOD(count: Int) async throws -> [APODResponse]
}
