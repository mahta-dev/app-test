import Foundation

struct ShortenedURLEntity: Equatable, Hashable {
    let id: String
    let originalURL: String
    let shortURL: String
    let alias: String
    let createdAt: Date
    
    init(id: String, originalURL: String, shortURL: String, alias: String, createdAt: Date = Date()) {
        self.id = id
        self.originalURL = originalURL
        self.shortURL = shortURL
        self.alias = alias
        self.createdAt = createdAt
    }
}

extension ShortenedURLEntity {
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
    
    var displayOriginalURL: String {
        if let url = URL(string: originalURL), let host = url.host {
            return host
        }
        return originalURL
    }
}
