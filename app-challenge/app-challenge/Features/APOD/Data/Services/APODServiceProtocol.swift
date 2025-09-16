import Foundation
import Network

protocol APODServiceProtocol {
    func fetchAPOD(date: String) async throws -> APODResponse
    func fetchRandomAPOD(count: Int) async throws -> [APODResponse]
}
