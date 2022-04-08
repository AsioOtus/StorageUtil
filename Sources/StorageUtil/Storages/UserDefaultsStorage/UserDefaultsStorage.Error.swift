extension UserDefaultsStorage {
	public enum Error: StorageUtilError {
		case codingError(JSONCoder.Error)
		case unexpectedError(Swift.Error)
		
		private var innerError: Swift.Error? {
			let resultError: Swift.Error?
			
			switch self {
			case .unexpectedError(let error):
				resultError = error
			default:
				resultError = nil
			}
			
			return resultError
		}
		
		public var description: String {
			let description: String
			
			switch self {
			case .codingError(let error):
				description = "UserDefaultsStorage – Coding error – \(error.description)"
			case .unexpectedError(let error):
				description = "UserDefaultsStorage – Unexpected error - \(error.localizedDescription)"
			}
			
			return description
		}
		
		public init (_ error: Self) {
			if let innerError = error.innerError as? Self {
				self = innerError
			} else {
				self = error
			}
		}
	}
}
