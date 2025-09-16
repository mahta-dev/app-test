import Foundation
import Network

struct APODErrorModel: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let recoverySuggestion: String?
    let errorType: ErrorType
    let timestamp: Date
    let canRetry: Bool
    
    enum ErrorType {
        case network
        case server
        case decoding
        case timeout
        case cancelled
        case unknown
    }
    
    init(from error: Error) {
        self.timestamp = Date()
        
        if let requestError = error as? RequestError {
            switch requestError {
            case .networkError:
                self.errorType = .network
                self.title = "Network Error"
                self.message = requestError.errorDescription ?? "Network connection failed"
                self.recoverySuggestion = requestError.recoverySuggestion
                self.canRetry = true
                
            case .httpError(let statusCode, let message, _):
                self.errorType = .server
                self.title = "Server Error"
                self.message = message ?? "Server returned error \(statusCode)"
                self.recoverySuggestion = requestError.recoverySuggestion
                self.canRetry = statusCode >= 500
                
            case .decodingError:
                self.errorType = .decoding
                self.title = "Data Error"
                self.message = requestError.errorDescription ?? "Failed to decode response"
                self.recoverySuggestion = requestError.recoverySuggestion
                self.canRetry = false
                
            case .timeout:
                self.errorType = .timeout
                self.title = "Timeout"
                self.message = "Request timed out"
                self.recoverySuggestion = requestError.recoverySuggestion
                self.canRetry = true
                
            case .cancelled:
                self.errorType = .cancelled
                self.title = "Cancelled"
                self.message = "Request was cancelled"
                self.recoverySuggestion = nil
                self.canRetry = true
                
            default:
                self.errorType = .unknown
                self.title = "Unknown Error"
                self.message = requestError.errorDescription ?? "An unknown error occurred"
                self.recoverySuggestion = requestError.recoverySuggestion
                self.canRetry = true
            }
        } else {
            self.errorType = .unknown
            self.title = "Error"
            self.message = error.localizedDescription
            self.recoverySuggestion = nil
            self.canRetry = true
        }
    }
    
    var iconName: String {
        switch errorType {
        case .network: return "wifi.slash"
        case .server: return "server.rack"
        case .decoding: return "doc.badge.gearshape"
        case .timeout: return "clock"
        case .cancelled: return "xmark.circle"
        case .unknown: return "exclamationmark.triangle"
        }
    }
    
    var iconColor: String {
        switch errorType {
        case .network: return "blue"
        case .server: return "red"
        case .decoding: return "orange"
        case .timeout: return "yellow"
        case .cancelled: return "gray"
        case .unknown: return "orange"
        }
    }
}
