import Foundation

protocol APODUseCaseProtocol {
    func fetchAPOD(for date: String) async throws -> APODEntity
    func fetchRandomAPOD(count: Int) async throws -> [APODEntity]
}
