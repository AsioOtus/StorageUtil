import os

extension Keychain.GenericPassword.Logger {
	struct Record {
		let operation: Operation
		let identifier: String
		let query: [CFString: Any]
		
		init (_ operation: Operation, _ identifier: String, _ query: [CFString: Any]) {
			self.operation = operation
			self.identifier = identifier
			self.query = query
		}
		
		func info (_ success: Success) -> Info {
			let info = Info(
				identifier: identifier,
				operation: operation.name,
				value: value(from: success),
				query: String(describing: query),
				error: nil,
				level: .default
			)
			
			return info
		}
		
		func info (_ failure: Failure) -> Info {
			let info = Info(
				identifier: identifier,
				operation: operation.name,
				value: operation.value,
				query: String(describing: query),
				error: failure.info,
				level: .error
			)
			
			return info
		}
		
		private func value (from success: Success) -> String? {
			var value = operation.value
			
			if let successValue = success.value {
				if let unwrappedValue = value {
					value = "\(unwrappedValue) – \(successValue)"
				} else {
					value = successValue
				}
			}
			
			return value
		}
	}
}



extension Keychain.GenericPassword.Logger.Record {
	struct Info {
		let identifier: String
		let operation: String
		let value: String?
		let query: String
		let error: String?
		let level: OSLogType
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
		
		var value: String? {
			let value: String?
			
			if case .saving(let item) = self {
				value = String(describing: item)
			} else {
				value = nil
			}
			
			return value
		}
	}
}



extension Keychain.GenericPassword.Logger.Record {
	enum Success {
		case saving
		case loading(ItemType)
		case deletion(Bool)
		case existance(Bool, ItemType? = nil)
		
		var value: String? {
			var value: String?
			
			switch self {
			case .saving:
				value = nil
			case .loading(let item):
				value = String(describing: item)
			case .deletion(let isExisted):
				value = String(isExisted)
			case .existance(let isExist, let item):
				value = String(isExist)
				
				if let item = item, let unwrappedValue = value {
					value = "\(unwrappedValue) – \(String(describing: item))"
				}
			}
			
			return value
		}
	}
}



extension Keychain.GenericPassword.Logger.Record {
	enum Failure {
		case codingError(Keychain.GenericPassword<ItemType>.Error.Category.Coding)
		case keychainError(Keychain.Error)
		case genericError(Error)
		
		var info: String? {
			var info: String?
			
			switch self {
			case .codingError(let error):
				info = String(describing: error)
			case .keychainError(let error):
				info = error.log
			case .genericError(let error):
				info = String(describing: error)
			}
			
			if let unwrappedInfo = info {
				info = "ERROR – \(unwrappedInfo)"
			}
			
			return info
		}
	}
}
