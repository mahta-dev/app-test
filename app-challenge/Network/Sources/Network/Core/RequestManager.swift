import Foundation

public struct RequestManager: RequestManagerProtocol, Sendable {
    
    private let baseURL: String
    private let requestExecutor: RequestExecutor
    private let retryManager: RetryManager

    public init(
        baseURL: String = "https://url-shortener-server.onrender.com",
        session: URLSessionProtocol = URLSession(configuration: .ephemeral),
        retryCount: Int = Int.defaultRetryCount,
        retryDelay: TimeInterval = 2.0
    ) {
        self.baseURL = baseURL
        self.requestExecutor = RequestExecutor(session: session)
        self.retryManager = RetryManager(retryCount: retryCount, retryDelay: retryDelay)
    }

    public func request<T: Decodable>(endpoint: EndPointType) async throws -> T {
        return try await retryManager.executeWithRetry {
            try await executeRequest(endpoint: endpoint)
        }
    }
    
    private func executeRequest<T: Decodable>(endpoint: EndPointType) async throws -> T {
        let url = try URLBuilder.buildURL(baseURL: baseURL, endpoint: endpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue

        if let headers = endpoint.headers {
            request.allHTTPHeaderFields = headers
        }
        
        if let body = endpoint.body {
            request.httpBody = body
        }

        do {
            return try await requestExecutor.execute(request: request)
        } catch let urlError as URLError {
            throw ErrorHandler.handleURLError(urlError)
        } catch let requestError as RequestError {
            throw requestError
        } catch let decodingError as DecodingError {
            throw decodingError
        } catch {
            throw RequestError.networkError(error.localizedDescription)
        }
    }
}
