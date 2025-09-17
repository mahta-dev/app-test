import Foundation

public struct URLBuilder: Sendable {
    
    public static func buildURL(baseURL: String, endpoint: EndPointType) throws -> URL {
        var fullURL = baseURL + endpoint.path
        let queryParams = endpoint.queryParameters
        
        fullURL = addQueryParameters(queryParams, to: fullURL)
        
        guard let url = URL(string: fullURL) else {
            throw RequestError.invalidURL
        }
        
        return url
    }
    
    private static func addQueryParameters(_ parameters: [String: Any], to url: String) -> String {
        guard !parameters.isEmpty, var urlComponents = URLComponents(string: url) else { return url }

        let queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }

        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url?.absoluteString ?? url
    }
}
