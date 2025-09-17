import Foundation
@testable import Network

public final class MockURLSession: URLSessionProtocol, Sendable {
    
    public var dataResult: Result<(Data, URLResponse), Error> = .failure(URLError(.unknown))
    public var capturedRequests: [URLRequest] = []
    
    public init() {}
    
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        capturedRequests.append(request)
        return try dataResult.get()
    }
    
    public func setSuccessResponse(data: Data, statusCode: Int = 200) {
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        dataResult = .success((data, response))
    }
    
    public func setErrorResponse(_ error: Error) {
        dataResult = .failure(error)
    }
    
    public func setURLError(_ code: URLError.Code) {
        dataResult = .failure(URLError(code))
    }
}
