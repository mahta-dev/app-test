import Foundation

final class APODTestFactory: APODFactoryProtocol {
    
    func createAPODView() -> APODContentView<APODViewModel> {
        let mockRepository = MockAPODRepository()
        let useCase = APODUseCase(repository: mockRepository)
        let viewModel = APODViewModel(useCase: useCase)
        return APODContentView(viewModel: viewModel)
    }
}

class MockAPODRepository: APODRepositoryProtocol {
    func fetchAPOD(date: String) async throws -> APODResponse {
        return APODResponse(
            date: date,
            explanation: "This is a mock APOD for testing purposes.",
            hdurl: "https://example.com/mock-hd-image.jpg",
            mediaType: "image",
            serviceVersion: "v1",
            title: "Mock APOD",
            url: "https://example.com/mock-image.jpg",
            thumbnailUrl: "https://example.com/mock-thumbnail.jpg"
        )
    }
    
    func fetchRandomAPOD(count: Int) async throws -> [APODResponse] {
        return [APODResponse(
            date: "2024-01-01",
            explanation: "This is a mock random APOD for testing purposes.",
            hdurl: "https://example.com/mock-random-hd-image.jpg",
            mediaType: "image",
            serviceVersion: "v1",
            title: "Mock Random APOD",
            url: "https://example.com/mock-random-image.jpg",
            thumbnailUrl: "https://example.com/mock-random-thumbnail.jpg"
        )]
    }
}