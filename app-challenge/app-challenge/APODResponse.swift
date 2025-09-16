import Foundation

public struct APODResponse: Codable, Sendable {
    public let date: String
    public let explanation: String
    public let hdurl: String?
    public let mediaType: String
    public let serviceVersion: String
    public let title: String
    public let url: String
    public let thumbnailUrl: String?
    
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
