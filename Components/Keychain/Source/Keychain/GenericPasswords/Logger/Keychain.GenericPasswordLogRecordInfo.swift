import os

extension Keychain {
	public struct GenericPasswordLogRecordInfo {
		public let keychainIdentifier: String?
		public let identifier: String
		public let operation: String
		public let value: String?
		public let query: String?
		public let error: String?
		public let level: OSLogType
		
		public var message: String {
			var message = "\(identifier) – \(operation)"
			
			if let keychainIdentifier = keychainIdentifier {
				message = "\(keychainIdentifier) – \(message)"
			}
			
			if let value = value {
				message += " – \(value)"
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
