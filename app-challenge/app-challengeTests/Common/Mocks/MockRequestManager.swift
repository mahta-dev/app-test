import Foundation
@testable import app_challenge
@testable import Network

class MockRequestManager: RequestManagerProtocol {
    var requestCalled = false
    var requestResult: Result<Any, Error> = .failure(TestError.mockError)
    
    func request<T: Decodable>(endpoint: EndPointType) async throws -> T {
        requestCalled = true
        
        switch requestResult {
        case .success(let data):
            if let typedData = data as? T {
                return typedData
            } else {
                throw TestError.mockError
            }
        case .failure(let error):
            throw error
        }
    }
}
