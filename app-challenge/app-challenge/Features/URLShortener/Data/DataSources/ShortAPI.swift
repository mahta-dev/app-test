import Foundation
import Network

public enum ShortAPI: EndPointType {
    
    case create(url: URL)
    case resolve(alias: String)

    public var path: String {
        switch self {
        case .create:                return "/api/alias"
        case .resolve(let alias):    return "/api/alias/\(alias)"
        }
    }

    public var httpMethod: HTTPMethod {
        switch self {
        case .create:  return .post
        case .resolve: return .get
        }
    }

    public var headers: [String : String]? {
        switch self {
        case .create:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        case .resolve:
            return ["Accept": "application/json"]
        }
    }

    public var queryParameters: [String : Any] { [:] }

    public var body: Data? {
        switch self {
        case .create(let url):
            struct ShortenRequest: Encodable { let url: String }
            return try? JSONEncoder().encode(ShortenRequest(url: url.absoluteString))
        case .resolve:
            return nil  
        }
    }
}
