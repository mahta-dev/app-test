import Foundation

final class APODUseCase: APODUseCaseProtocol {
    private let repository: APODRepositoryProtocol
    
    init(repository: APODRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchAPOD(for date: String) async throws -> APODEntity {
        let response = try await repository.fetchAPOD(date: date)
        return APODEntity(
            title: response.title,
            date: response.date,
            explanation: response.explanation,
            url: response.url,
            mediaType: response.mediaType,
            copyright: nil,
            hdurl: response.hdurl,
            serviceVersion: response.serviceVersion,
            thumbnailUrl: response.thumbnailUrl
        )
    }
    
    func fetchRandomAPOD(count: Int) async throws -> [APODEntity] {
        let responses = try await repository.fetchRandomAPOD(count: count)
        return responses.map { response in
            APODEntity(
                title: response.title,
                date: response.date,
                explanation: response.explanation,
                url: response.url,
                mediaType: response.mediaType,
                copyright: nil,
                hdurl: response.hdurl,
                serviceVersion: response.serviceVersion,
                thumbnailUrl: response.thumbnailUrl
            )
        }
    }
}
