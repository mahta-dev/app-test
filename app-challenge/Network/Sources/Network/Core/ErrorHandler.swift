import Foundation

public struct ErrorHandler: Sendable {
    
    public static func handleURLError(_ urlError: URLError) -> RequestError {
        switch urlError.code {
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        case .networkConnectionLost:
            return .networkError("Network connection lost (-1005) - Please try again")
        case .notConnectedToInternet:
            return .networkError("No internet connection")
        case .cannotConnectToHost:
            return .networkError("Unable to connect to server")
        case .cannotFindHost:
            return .networkError("Server not found")
        case .dnsLookupFailed:
            return .networkError("DNS resolution failed")
        case .cannotLoadFromNetwork:
            return .networkError("Error loading data from network")
        default:
            return .networkError("Network error: \(urlError.localizedDescription) (Code: \(urlError.code.rawValue))")
        }
    }
}
