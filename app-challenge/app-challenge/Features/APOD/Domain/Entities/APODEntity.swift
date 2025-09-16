import Foundation

struct APODEntity {
    let title: String
    let date: String
    let explanation: String
    let url: String
    let mediaType: String
    let copyright: String?
    let hdurl: String?
    let serviceVersion: String?
    let thumbnailUrl: String?
    
    init(title: String, date: String, explanation: String, url: String, mediaType: String, copyright: String? = nil, hdurl: String? = nil, serviceVersion: String? = nil, thumbnailUrl: String? = nil) {
        self.title = title
        self.date = date
        self.explanation = explanation
        self.url = url
        self.mediaType = mediaType
        self.copyright = copyright
        self.hdurl = hdurl
        self.serviceVersion = serviceVersion
        self.thumbnailUrl = thumbnailUrl
    }
}

extension APODEntity {
    var isImage: Bool {
        return mediaType.lowercased() == "image"
    }
    
    var isVideo: Bool {
        return mediaType.lowercased() == "video"
    }
    
    var displayUrl: String {
        return hdurl ?? url
    }
}
