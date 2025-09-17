import Foundation
import Network

public class URLShortenerTest {
    
    public static func testURLShortenerAPI() async {
        do {
            print("🧪 Testing URL Shortener API with new RequestManager...")
            
            let service = URLShortenerService()
            
            let testURL = URL(string: "https://www.apple.com")!
            print("🚀 Shortening URL: \(testURL.absoluteString)")
            
            let shortenResponse = try await service.shortenURL(testURL)
            print("✅ Shorten Response: \(shortenResponse)")
            
            print("🔍 Resolving alias: \(shortenResponse.alias)")
            let resolveResponse = try await service.resolveURL(alias: shortenResponse.alias)
            print("✅ Resolve Response: \(resolveResponse)")
            
            print("🎉 URL Shortener Test SUCCESS!")
            
        } catch {
            print("❌ URL Shortener Test FAILED!")
            print("   Error: \(error)")
        }
    }
}
