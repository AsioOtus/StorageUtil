import os.log

extension UserDefaults.Item.Logger.Record.Commit {
	public struct Info {
		public let userDefaultsIdentifier: String?
		public let key: String
		public let operation: String
		public let existance: Bool?
		public let value: ItemType?
		public let error: Error?
		public let level: OSLogType
		
		public var defaultMessage: String {
			var message = "\(key) – \(operation)"
			
			if let userDefaultsIdentifier = userDefaultsIdentifier {
				message = "\(userDefaultsIdentifier) – \(message)"
			}
			
			if let existance = existance {
				message += " – \(existance)"
			}
			
			if let value = value {
				message += " – \(value)"
			}
			
			if let error = error {
				message += " – ERROR – \(error)"
			}
			
			return message
		}
	}
}
