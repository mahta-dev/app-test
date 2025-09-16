import Foundation

public struct SafeDictionary: Sendable, Equatable {
    let values: [String: CodableValue]

    init(values: [String: CodableValue]) {
        self.values = values
    }

    public static func from(data: Data) -> SafeDictionary? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let dictionary = json as? [String: Any] else {
            return nil
        }

        let codableValues = dictionary.compactMapValues { value -> CodableValue? in
            if let stringValue = value as? String {
                return .string(stringValue)
            } else if let intValue = value as? Int {
                return .int(intValue)
            } else if let doubleValue = value as? Double {
                return .double(doubleValue)
            } else if let boolValue = value as? Bool {
                return .bool(boolValue)
            }
            return nil
        }

        return SafeDictionary(values: codableValues)
    }
}

public enum CodableValue: Sendable, Equatable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
}
