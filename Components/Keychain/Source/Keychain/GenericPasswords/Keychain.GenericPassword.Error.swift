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
		}
		
		public enum Coding: KeychainError {
			case itemIsNotData
			case encodingFailed(Swift.Error)
			case decodingFailed(Swift.Error)
		}
	}
}



extension Keychain.GenericPassword.Error: CustomStringConvertible {
	public var description: String { "\(identifier) – \(category.description)" }
}



extension Keychain.GenericPassword.Error.Category: CustomStringConvertible {
	public var description: String {
		let log: String
		
		switch self {
		case .codingError(let error):
			log = "Coding error: \(error)"
		case .keychainError(let error):
			log = "Keychain error: \(error)"
		case .error(let error):
			log = "Error: \(error)"
		}
		
		return log
	}
}



extension Keychain.GenericPassword.Error.Coding: CustomStringConvertible {
	public var description: String {
		let log: String
		
		switch self {
		case .itemIsNotData:
			log = "Item cannot be interpreted as Data"
		case .encodingFailed(let error):
			log = "Encoding failed: \(error)"
		case .decodingFailed(let error):
			log = "Decoding failed: \(error)"
		}
		
		return log
	}
}
