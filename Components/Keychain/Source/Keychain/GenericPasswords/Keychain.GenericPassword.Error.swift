extension Keychain.GenericPassword {
	public struct Error: KeychainError {
		public let category: Category
		public let identifier: String
		
		internal init (_ identifier: String, _ category: Category) {
			self.identifier = identifier
			self.category = category
		}
		
		public enum Category {
			case codingError(Coding)
			case keychainError(Keychain.Error)
			case error(Swift.Error)
			
			public enum Coding: KeychainError {
				case itemIsNotData
				case encodingFailed(Swift.Error)
				case decodingFailed(Swift.Error)
			}
		}
	}
}



extension Keychain.GenericPassword.Error: KeychainLoggable {
	public var keychainLog: String { "\(identifier) – \(category.keychainLog)" }
}



extension Keychain.GenericPassword.Error.Category: KeychainLoggable {
	public var keychainLog: String {
		let log: String
		
		switch self {
		case .codingError(let error):
			log = "Coding error: \(error.keychainLog)"
		case .keychainError(let error):
			log = "Keychain error: \(error.keychainLog)"
		case .error(let error):
			log = "Error: \(error)"
		}
		
		return log
	}
}



extension Keychain.GenericPassword.Error.Category.Coding: KeychainLoggable {
	public var keychainLog: String {
		let log: String
		
		switch self {
		case .itemIsNotData:
			log = "Item is not data"
		case .encodingFailed(let error):
			log = "Encoding failed: \(error)"
		case .decodingFailed(let error):
			log = "Decoding failed: \(error)"
		}
		
		return log
	}
}
