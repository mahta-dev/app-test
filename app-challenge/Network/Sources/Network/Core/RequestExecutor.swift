import Foundation

public struct RequestExecutor: Sendable {
    
    private let session: URLSessionProtocol
    
    public init(session: URLSessionProtocol) {
        self.session = session
    }
    
    public func execute<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.invalidResponse
        }

        RequestLogger().logRequest(data: data, response: httpResponse, error: nil)

        guard 200...299 ~= httpResponse.statusCode else {
            let errorMessage = String(data: data, encoding: .utf8)
            let jsonResponse = SafeDictionary.from(data: data)
            throw RequestError.httpError(statusCode: httpResponse.statusCode, message: errorMessage, data: jsonResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
