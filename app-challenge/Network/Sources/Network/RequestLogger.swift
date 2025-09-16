import Foundation

public protocol RequestLoggerProtocol: Sendable {
    func logRequest(data: Data?, response: HTTPURLResponse?, error: Error?)
}

public final class RequestLogger: RequestLoggerProtocol, @unchecked Sendable {
    private let isEnabled: Bool
    
    public init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
    
    public func logRequest(data: Data?, response: HTTPURLResponse?, error: Error?) {
        guard isEnabled else { return }
        print(buildLogMessage(data: data, response: response, error: error))
    }
    
    private func buildLogMessage(data: Data?, response: HTTPURLResponse?, error: Error?) -> String {
        var message = "\n🌐 NETWORK REQUEST LOG\n"
        message += "═══════════════════════════════════════\n"
        
        if let url = response?.url?.absoluteString {
            message += "📍 URL: \(url)\n"
        }
        
        if let statusCode = response?.statusCode {
            let statusIcon = statusCode >= 200 && statusCode < 300 ? "✅" : "❌"
            message += "\(statusIcon) Status: \(statusCode)\n"
        }
        
        if let headers = response?.allHeaderFields, !headers.isEmpty {
            message += "📋 Headers:\n"
            headers.forEach { message += "   • \($0.key): \($0.value)\n" }
        }
        
        if let data = data, let bodyString = String(data: data, encoding: .utf8) {
            message += "📄 JSON Response:\n"
            message += formatJSONString(bodyString)
            message += "\n"
        }
        
        if let error = error {
            message += "⚠️  Error: \(error.localizedDescription)\n"
        }
        
        message += "═══════════════════════════════════════\n"
        return message
    }
    
    private func formatJSONString(_ jsonString: String) -> String {
        if let jsonData = jsonString.data(using: .utf8),
           let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        }
        return jsonString
    }
}