import Foundation

struct APODResponse: Codable, Sendable {
    let date: String
    let explanation: String
    let hdurl: String?
    let mediaType: String
    let serviceVersion: String
    let title: String
    let url: String
    let thumbnailUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title
        case url
        case thumbnailUrl = "thumbnail_url"
    }
}
