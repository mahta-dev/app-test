import Foundation

public enum RequestError: Error, Sendable, LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, message: String?, data: SafeDictionary?)
    case decodingError(String)
    case networkError(String)
    case timeout
    case cancelled
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .httpError(let statusCode, let message, _):
            return "HTTP Error \(statusCode): \(message ?? "Unknown error")"
        case .decodingError(let message):
            return "Decoding Error: \(message)"
        case .networkError(let message):
            return "Network Error: \(message)"
        case .timeout:
            return "Request timeout"
        case .cancelled:
            return "Request cancelled"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid"
        case .invalidResponse:
            return "The response is not a valid HTTP response"
        case .httpError(let statusCode, _, _):
            return "Server returned status code \(statusCode)"
        case .decodingError(let message):
            return "Failed to decode response: \(message)"
        case .networkError(let message):
            return "Network connection failed: \(message)"
        case .timeout:
            return "The request timed out"
        case .cancelled:
            return "The request was cancelled"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Check the URL format"
        case .invalidResponse:
            return "Verify the server is responding correctly"
        case .httpError(let statusCode, _, _):
            if statusCode >= 500 {
                return "Try again later, server error"
            } else if statusCode == 404 {
                return "Check if the endpoint exists"
            } else if statusCode == 401 {
                return "Check your authentication"
            } else {
                return "Check your request parameters"
            }
        case .decodingError:
            return "Check if the response format matches expected model"
        case .networkError:
            return "Check your internet connection"
        case .timeout:
            return "Try again with a longer timeout"
        case .cancelled:
            return "The request was cancelled, try again"
        }
    }
}
