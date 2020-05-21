import os

public extension Keychain.GenericPassword.Logger {
	struct Record {
		let identifier: String
		let query: [CFString: Any]
		let operation: Operation
		
		init (_ operation: Operation, _ identifier: String, _ query: [CFString: Any]) {
			self.operation = operation
			self.identifier = identifier
			self.query = query
		}
		
		func commit (_ resolving: Resolving) -> Commit {
			let commit = Commit(
				identifier: identifier,
				query: query,
				operation: operation,
				resolving: resolving
			)
			
			return commit
		}
	}
}



extension Keychain.GenericPassword.Logger.Record {
	enum Operation {
		case saving(ItemType)
		case loading
		case deletion
		case existance
		
		var name: String {
			let name: String
			
			switch self {
			case .saving:
				name = "SAVING"
			case .loading:
				name = "LOADING"
			case .deletion:
				name = "DELETION"
			case .existance:
				name = "EXISTANCE"
			}
			
			return name
		}
		
		var value: ItemType? {
			let value: ItemType?
			
			if case .saving(let item) = self {
				value = item
			} else {
				value = nil
			}
			
			return value
		}
	}
}



extension Keychain.GenericPassword.Logger.Record {
	enum Resolving {
		case saving
		case loading(ItemType)
		case deletion(Bool)
		case existance(Bool, ItemType? = nil)
		
		case codingError(Keychain.GenericPassword<ItemType>.Error.Category.Coding)
		case keychainError(Keychain.Error)
		case genericError(Error)
		
		
		
		var value: ItemType? {
			let value: ItemType?
			
			switch self {
			case .loading(let item):
				value = item
			case .existance(_, let item):
				value = item
			default:
				value = nil
			}
			
			return value
		}
		
		var isExists: Bool? {
			let isExists: Bool?
			
			switch self {
			case .deletion(let isExisted):
				isExists = isExisted
			case .existance(let existance, _):
				isExists = existance
			default:
				isExists = nil
			}
			
			return isExists
		}
		
		var errorType: String? {
			let errorType: String?
			
			switch self {
			case .codingError:
				errorType = "CODING ERROR"
			case .keychainError:
				errorType = "KEYCHAIN ERROR"
			case .genericError:
				errorType = "ERROR"
			default:
				errorType = nil
			}
			
			return errorType
		}
		
		var error: Error? {
			let error: Error?
			
			switch self {
			case .codingError(let codingError):
				error = codingError
			case .keychainError(let keychainError):
				error = keychainError
			case .genericError(let genericError):
				error = genericError
			default:
				error = nil
			}
			
			return error
		}
		
		var level: OSLogType {
			let level: OSLogType
			
			switch self {
			case .saving:
				level = .info
			case .loading:
				level = .default
			case .deletion:
				level = .info
			case .existance:
				level = .default
			case .codingError:
				level = .error
			case .keychainError:
				level = .error
			case .genericError:
				level = .error
			}
			
			return level
		}
	}
}



extension Keychain.GenericPassword.Logger.Record {
	struct Commit {
		let identifier: String
		let query: [CFString: Any]
		let operation: Operation
		let resolving: Resolving
		
		var value: ItemType? {
			let value: ItemType?
			
			if let operationValue = operation.value {
				value = operationValue
			} else if let resolvingValue = resolving.value {
				value = resolvingValue
			} else {
				value = nil
			}
			
			return value
		}
	}
}
