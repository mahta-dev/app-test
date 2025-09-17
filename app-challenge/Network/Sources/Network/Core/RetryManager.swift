import Foundation

public struct RetryManager: Sendable {
    
    private let retryCount: Int
    private let retryDelay: TimeInterval
    
    private static let maxRetryDelay: TimeInterval = 8.0
    private static let jitterRange: ClosedRange<Double> = 0...0.4
    
    public init(retryCount: Int = Int.defaultRetryCount, retryDelay: TimeInterval = 2.0) {
        self.retryCount = retryCount
        self.retryDelay = retryDelay
    }
    
    public func executeWithRetry<T>(operation: @escaping () async throws -> T) async throws -> T {
        let maxAttempts = retryCount + 1
        
        for attempt in 0..<maxAttempts {
            do {
                return try await operation()
            } catch {
                let isLastAttempt = attempt == maxAttempts - 1
                let canRetry = canRetryRequest(for: error)
                
                if isLastAttempt || !canRetry {
                    throw normalizeError(error)
                }
                
                try await waitBeforeRetry(attempt: attempt)
            }
        }
        
        throw RequestError.networkError("Unexpected retry loop exit")
    }
    
    private func canRetryRequest(for error: Error) -> Bool {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut, .networkConnectionLost, .notConnectedToInternet,
                 .cannotConnectToHost, .cannotFindHost, .dnsLookupFailed, .cannotLoadFromNetwork:
                return true
            default:
                return false
            }
        }
        
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
    
    private func waitBeforeRetry(attempt: Int) async throws {
        let baseDelay = retryDelay * pow(2.0, Double(attempt))
        let jitter = Double.random(in: Self.jitterRange)
        let finalDelay = min(Self.maxRetryDelay, baseDelay + jitter)
        
        let delayInNanoseconds = UInt64(finalDelay * TimeInterval.nanosecondsPerSecond)
        try await Task.sleep(nanoseconds: delayInNanoseconds)
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
}
