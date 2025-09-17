import Foundation

public struct ShortenResponse: Codable {
    public struct Links: Codable {
        public let self_: URL
        public let short: URL
        private enum CodingKeys: String, CodingKey { case self_ = "self", short }
    }
    public let alias: String
    public let _links: Links
}

public struct ResolveResponse: Decodable {
    public let url: URL
}
