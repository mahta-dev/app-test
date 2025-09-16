// MARK: - Exemplos de Uso do RequestError em Todo o Projeto

import Foundation
import Network

// MARK: - 1. Service Layer Example
protocol UserServiceProtocol {
    func fetchUser(id: String) async throws -> User
    func updateUser(_ user: User) async throws -> User
}

class UserService: UserServiceProtocol {
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func fetchUser(id: String) async throws -> User {
        // ✅ CORRETO: RequestError é retornado automaticamente pelo RequestManager
        return try await requestManager.request(endpoint: UserEndpoint.user(id: id))
    }
    
    func updateUser(_ user: User) async throws -> User {
        // ✅ CORRETO: RequestError é retornado automaticamente pelo RequestManager
        return try await requestManager.request(endpoint: UserEndpoint.updateUser(user))
    }
}

// MARK: - 2. ViewModel Layer Example
class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var error: UserErrorModel?
    @Published var isLoading = false
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func loadUser(id: String) {
        Task { @MainActor in
            isLoading = true
            error = nil
            
            do {
                let user = try await userService.fetchUser(id: id)
                self.user = user
            } catch {
                // ✅ CORRETO: Mapear RequestError para modelo de UI
                self.error = UserErrorModel(from: error)
            }
            
            isLoading = false
        }
    }
}

// MARK: - 3. Error Model Example
struct UserErrorModel: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let recoverySuggestion: String?
    let canRetry: Bool
    
    init(from error: Error) {
        if let requestError = error as? RequestError {
            switch requestError {
            case .networkError:
                self.title = "Connection Error"
                self.message = requestError.errorDescription ?? "Network connection failed"
                self.recoverySuggestion = requestError.recoverySuggestion
                self.canRetry = true
                
            case .httpError(let statusCode, let message, _):
                self.title = "Server Error"
                self.message = message ?? "Server returned error \(statusCode)"
                self.recoverySuggestion = requestError.recoverySuggestion
                self.canRetry = statusCode >= 500
                
            case .decodingError:
                self.title = "Data Error"
                self.message = requestError.errorDescription ?? "Failed to decode response"
                self.recoverySuggestion = requestError.recoverySuggestion
                self.canRetry = false
                
            case .timeout:
                self.title = "Timeout"
                self.message = "Request timed out"
                self.recoverySuggestion = requestError.recoverySuggestion
                self.canRetry = true
                
            case .cancelled:
                self.title = "Cancelled"
                self.message = "Request was cancelled"
                self.recoverySuggestion = nil
                self.canRetry = true
                
            default:
                self.title = "Unknown Error"
                self.message = requestError.errorDescription ?? "An unknown error occurred"
                self.recoverySuggestion = requestError.recoverySuggestion
                self.canRetry = true
            }
        } else {
            // Fallback para outros tipos de erro
            self.title = "Error"
            self.message = error.localizedDescription
            self.recoverySuggestion = nil
            self.canRetry = true
        }
    }
}

// MARK: - 4. Endpoint Example
enum UserEndpoint: EndPointType {
    case user(id: String)
    case updateUser(User)
    
    var path: String {
        switch self {
        case .user(let id):
            return "/users/\(id)"
        case .updateUser:
            return "/users"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .user:
            return .get
        case .updateUser:
            return .put
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    var queryParameters: [String: Any] {
        return [:]
    }
    
    var body: Data? {
        switch self {
        case .user:
            return nil
        case .updateUser(let user):
            return try? JSONEncoder().encode(user)
        }
    }
    
    var requiresAuth: Bool {
        return true
    }
}

// MARK: - 5. Model Example
struct User: Codable {
    let id: String
    let name: String
    let email: String
}

// MARK: - 6. ❌ EXEMPLOS INCORRETOS (NÃO FAZER)

// ❌ ERRADO: Criar enum de erro customizado
enum UserError: Error {
    case userNotFound
    case invalidData
    case networkFailure
}

// ❌ ERRADO: Usar URLError diretamente
func badExample() async throws -> User {
    do {
        // ... código ...
    } catch let urlError as URLError {
        throw urlError // ❌ NÃO FAZER
    }
}

// ❌ ERRADO: Usar strings para erros
func anotherBadExample() async throws -> User {
    guard let user = user else {
        throw "User not found" // ❌ NÃO FAZER
    }
    return user
}

// MARK: - 7. ✅ EXEMPLOS CORRETOS

// ✅ CORRETO: Usar RequestError
func goodExample() async throws -> User {
    guard let user = user else {
        throw RequestError.networkError("User not found") // ✅ CORRETO
    }
    return user
}

// ✅ CORRETO: Mapear RequestError para UI
func handleError(_ error: Error) -> UserErrorModel {
    return UserErrorModel(from: error) // ✅ CORRETO
}
