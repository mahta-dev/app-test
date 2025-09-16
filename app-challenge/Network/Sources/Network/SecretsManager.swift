import Foundation

public final class SecretsManager: Sendable {
    public static let shared = SecretsManager()
    
    private init() {}
    
    public var apiKey: String {
        return "DEMO_KEY"
    }
}
