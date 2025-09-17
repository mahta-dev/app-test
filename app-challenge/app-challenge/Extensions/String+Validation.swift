import Foundation

extension String {
    
    var isValidURL: Bool {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedString.isEmpty {
            return false
        }
        
        if trimmedString.allSatisfy({ $0.isNumber }) {
            return false
        }
        
        if trimmedString.contains(" ") {
            return false
        }
        
        guard let url = URL(string: trimmedString) else {
            return false
        }
        
        guard let scheme = url.scheme else {
            return false
        }
        
        guard scheme == "http" || scheme == "https" else {
            return false
        }
        
        guard let host = url.host, !host.isEmpty else {
            return false
        }
        
        return true
    }
    
    var isValidEmail: Bool {
        let emailPattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let regex = try? NSRegularExpression(pattern: emailPattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        
        return regex?.firstMatch(in: self, options: [], range: range) != nil
    }
    
    var isValidPhoneNumber: Bool {
        let phonePattern = #"^[\+]?[1-9][\d]{0,15}$"#
        let regex = try? NSRegularExpression(pattern: phonePattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        
        return regex?.firstMatch(in: self, options: [], range: range) != nil
    }
    
    var isNumeric: Bool {
        return self.allSatisfy { $0.isNumber }
    }
    
    var isAlphabetic: Bool {
        return self.allSatisfy { $0.isLetter }
    }
    
    var isAlphanumeric: Bool {
        return self.allSatisfy { $0.isLetter || $0.isNumber }
    }
    
    var isValidAlias: Bool {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedString.isEmpty {
            return false
        }
        
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_"))
        return trimmedString.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }
    }
    
    func normalizedURL() -> String {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedString.hasPrefix("http://") || trimmedString.hasPrefix("https://") {
            return trimmedString
        }
        
        return "https://" + trimmedString
    }
}
