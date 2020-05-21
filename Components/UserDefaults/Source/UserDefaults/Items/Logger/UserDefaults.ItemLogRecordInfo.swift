import os

extension UserDefaults {
	public struct ItemLogRecordInfo {
		public let userDefaultsIdentifier: String?
		public let key: String
		public let operation: String
		public let value: String?
		public let error: String?
		public let level: OSLogType
		
		public var message: String {
			var message = "\(key) – \(operation)"
			
			if let userDefaultsIdentifier = userDefaultsIdentifier {
				message = "\(userDefaultsIdentifier) – \(message)"
			}
			
			if let value = value {
				message += " – \(value)"
			}
			
			if let error = error {
				message += " – \(error)"
			}
			
			return message
		}
	}
}
