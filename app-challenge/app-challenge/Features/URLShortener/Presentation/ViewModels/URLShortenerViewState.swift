import Foundation

enum URLShortenerViewState: Equatable {
    case idle
    case loading
    case success([ShortenedURLEntity])
    case error(URLShortenerErrorModel)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var shortenedURLs: [ShortenedURLEntity] {
        if case .success(let urls) = self {
            return urls
        }
        return []
    }
    
    var error: URLShortenerErrorModel? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
    
    var isEmpty: Bool {
        if case .idle = self {
            return true
        }
        return false
    }
}

struct URLShortenerErrorModel {
    let title: String
    let message: String
    let retryAction: (() -> Void)?
    
    init(title: String = "Error", message: String, retryAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.retryAction = retryAction
    }
}

extension URLShortenerErrorModel: Equatable {
    static func == (lhs: URLShortenerErrorModel, rhs: URLShortenerErrorModel) -> Bool {
        return lhs.title == rhs.title && lhs.message == rhs.message
    }
}
