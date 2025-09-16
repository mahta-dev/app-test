import Foundation
import Network

enum APODEndpoint: EndPointType {
    case apodByDate(date: String)
    case apodRandom(count: Int)
    case apodByRange(startDate: String, endDate: String, thumbs: Bool)
    
    var path: String {
        return "/planetary/apod"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    var queryParameters: [String: Any] {
        var params: [String: Any] = [:]
        
        switch self {
        case let .apodByDate(date):
            params["date"] = date
            
        case let .apodRandom(count):
            params["count"] = count
            
        case let .apodByRange(startDate, endDate, thumbs):
            params["start_date"] = startDate
            params["end_date"] = endDate
            if thumbs { params["thumbs"] = "true" }
        }
        
        return params
    }
    
    var body: Data? {
        return nil
    }
    
    var requiresAuth: Bool {
        return true
    }
}
