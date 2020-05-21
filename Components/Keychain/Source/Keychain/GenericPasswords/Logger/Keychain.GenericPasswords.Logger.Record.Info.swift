import os

public extension Keychain.GenericPassword.Logger.Record {
	struct Info {
		public let keychainIdentifier: String?
		public let identifier: String
		public let operation: String
		public let existance: Bool?
		public let value: ItemType?
		public let errorType: String?
		public let error: Error?
		public let query: [CFString: Any]?
		public let level: OSLogType
		
		public var defaultMessage: String {
			var message = "\(identifier) – \(operation)"
			
			if let keychainIdentifier = keychainIdentifier {
				message = "\(keychainIdentifier) – \(message)"
			}
			
			if let existance = existance {
				message += " – \(existance)"
			}
			
			if let value = value {
				message += " – \(value)"
			}
			
			if let errorType = errorType {
				message += " – \(errorType)"
			}
			
			if let error = error {
				message += " – \(error)"
			}
			
			if let query = query {
				message += " – \(query)"
			}
			
			return message
		}
	}
}
