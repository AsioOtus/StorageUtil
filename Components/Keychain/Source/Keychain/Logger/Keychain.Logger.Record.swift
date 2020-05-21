import os

public extension Keychain.Logger {
	struct Record {
		let operation: Operation
		let query: [CFString: Any]
		
		init (_ operation: Operation, _ query: [CFString: Any]) {
			self.operation = operation
			self.query = query
		}
		
		func commit (_ resolution: Resolution) -> Commit {
			let commit = Commit(
				operation: operation,
				query: query,
				resolution: resolution
			)
			
			return commit
		}
	}
}



extension Keychain.Logger.Record {
	enum Operation {
		case saving(Data)
		case loading
		case deletion
		case existance
		
		case clearingClass(Keychain.Class)
		case clearing
		
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
			case .clearingClass:
				name = "CLEARING CLASS"
			case .clearing:
				name = "CLEARING"
			}
			
			return name
		}
		
		var value: String? {
			if case .saving(let data) = self {
				return data.base64EncodedString()
			} else {
				return nil
			}
		}
	}
}



extension Keychain.Logger.Record {
	enum Resolution {
		case saving
		case loading(AnyObject)
		case deletion(Bool)
		case existance(Bool, AnyObject? = nil)
		
		case clearingClass(Keychain.Class, OSStatus)
		case clearing([Keychain.Class: OSStatus])
		
		case error(Error)
		
		
		
		var value: AnyObject? {
			let value: AnyObject?
			
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
		
		var clearingStatus: [Keychain.Class: OSStatus]? {
			let status: [Keychain.Class: OSStatus]?
			
			switch self {
			case .clearingClass(let keychainClass, let clearingStatus):
				status = [keychainClass: clearingStatus]
			case .clearing(let statuses):
				status = statuses
			default:
				status = nil
			}
			
			return status
		}
		
		var errorType: String? {
			if case .error = self {
				return "ERROR"
			} else {
				return nil
			}
		}
		
		var error: Error? {
			if case .error(let error) = self {
				return error
			} else {
				return nil
			}
		}
		
		var level: OSLogType {
			let level: OSLogType
			
			switch self {
			case .saving:
				level = .default
			case .loading:
				level = .default
			case .deletion:
				level = .default
			case .existance:
				level = .default
			case .clearingClass:
				level = .default
			case .clearing:
				level = .debug
			case .error:
				level = .info
			}
			
			return level
		}
	}
}



extension Keychain.Logger.Record {
	struct Commit {
		let operation: Operation
		let query: [CFString: Any]
		let resolution: Resolution
		
		var value: AnyObject? {
			let value: AnyObject?
			
			if let operationValue = operation.value {
				value = operationValue as AnyObject
			} else if let resolvingValue = resolution.value {
				value = resolvingValue
			} else {
				value = nil
			}
			
			return value
		}
	}
}
