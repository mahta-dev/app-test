import Foundation

extension TimeInterval {
    static let nanosecondsPerSecond: TimeInterval = 1_000_000_000
}

extension Int {
    static let serverErrorThreshold = 500
    public static let defaultRetryCount = 3
}

public protocol URLSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

public protocol RequestManagerProtocol: Sendable {
    func request<T: Decodable>(endpoint: EndPointType) async throws -> T
}

public struct RequestManager: RequestManagerProtocol, Sendable {
    let session: URLSessionProtocol
    private let apiKey: String
    private let baseURL: String = "https://api.nasa.gov"
    private let retryCount: Int
    private let retryDelay: TimeInterval
    
    private static let successStatusCodeRange = 200...299

    public init(
        session: URLSessionProtocol = URLSession.shared,
        retryCount: Int = Int.defaultRetryCount,
        retryDelay: TimeInterval = 1.0
    ) {
        self.session = session
        self.apiKey = SecretsManager.shared.apiKey
        self.retryCount = retryCount
        self.retryDelay = retryDelay
    }

    public func request<T: Decodable>(endpoint: EndPointType) async throws -> T {
        return try await performRequestWithRetry(endpoint: endpoint)
    }
    
    func performRequestWithRetry<T: Decodable>(endpoint: EndPointType) async throws -> T {
        let maxAttempts = retryCount + 1
        
        for attempt in 0..<maxAttempts {
            do {
                return try await executeRequest(endpoint: endpoint)
            } catch {
                let isLastAttempt = attempt == maxAttempts - 1
                let canRetry = canRetryRequest(for: error)
                
                if isLastAttempt || !canRetry {
                    throw normalizeError(error)
                }
                
                try await waitBeforeRetry()
            }
        }
        
        throw RequestError.networkError("Unexpected retry loop exit")
    }
    
    private func executeRequest<T: Decodable>(endpoint: EndPointType) async throws -> T {
        var fullURL = baseURL + endpoint.path
        var queryParams = endpoint.queryParameters

        queryParams["api_key"] = apiKey
        fullURL = addQueryParameters(queryParams, to: fullURL)

        guard let url = URL(string: fullURL) else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue

        if let headers = endpoint.headers {
            request.allHTTPHeaderFields = headers
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw RequestError.invalidResponse
            }

            RequestLogger().logRequest(data: data, response: httpResponse, error: nil)

            guard Self.successStatusCodeRange.contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data, encoding: .utf8)
                let jsonResponse = SafeDictionary.from(data: data)
                throw RequestError.httpError(statusCode: httpResponse.statusCode, message: errorMessage, data: jsonResponse)
            }

            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)

        } catch let urlError as URLError {
            throw handleURLError(urlError)
        } catch let requestError as RequestError {
            throw requestError
        } catch let decodingError as DecodingError {
            throw decodingError
        } catch {
            throw RequestError.networkError(error.localizedDescription)
        }
    }
    
    private func canRetryRequest(for error: Error) -> Bool {
        guard let requestError = error as? RequestError else { return false }
        
        switch requestError {
        case .timeout, .networkError:
            return true
        case .httpError(let statusCode, _, _):
            return statusCode >= Int.serverErrorThreshold
        default:
            return false
        }
    }
    
    private func waitBeforeRetry() async throws {
        let delayInNanoseconds = UInt64(retryDelay * TimeInterval.nanosecondsPerSecond)
        try await Task.sleep(nanoseconds: delayInNanoseconds)
    }
    
    private func handleURLError(_ urlError: URLError) -> RequestError {
        switch urlError.code {
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        default:
            return .networkError(urlError.localizedDescription)
        }
    }
    
    private func normalizeError(_ error: Error) -> Error {
        if let requestError = error as? RequestError {
            return requestError
        }
        if error is DecodingError {
            return error
        }
        return RequestError.networkError(error.localizedDescription)
    }

    private func addQueryParameters(_ parameters: [String: Any], to url: String) -> String {
        guard var urlComponents = URLComponents(string: url) else { return url }

        let queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }

        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url?.absoluteString ?? url
    }
}