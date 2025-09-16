import Foundation

enum APODViewState {
    case idle
    case loading
    case success(APODEntity)
    case error(APODErrorModel)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var apod: APODEntity? {
        if case .success(let apod) = self {
            return apod
        }
        return nil
    }
    
    var error: APODErrorModel? {
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
