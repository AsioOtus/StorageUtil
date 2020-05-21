import os

extension UserDefaults.Item.Logger {
	struct Record {
		let operation: Operation
		let key: String
		
		init (_ operation: Operation, _ key: String) {
			self.operation = operation
			self.key = key
		}
		
		func info (_ success: Success) -> Info {
			let info = Info(
				identifier: key,
				operation: operation.name,
				value: value(from: success),
				error: nil,
				level: .default
			)
			
			return info
		}
		
		func info (_ failure: Failure) -> Info {
			let info = Info(
				identifier: key,
				operation: operation.name,
				value: operation.value,
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



extension UserDefaults.Item.Logger.Record {
	struct Info {
		let identifier: String
		let operation: String
		let value: String?
		let error: String?
		let level: OSLogType
	}
}



extension UserDefaults.Item.Logger.Record {
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
				if let loggableItem = item as? UserDefaultsLoggable {
					value = loggableItem.userDefaultsLog
				} else {
					value = String(describing: item)
				}
			} else {
				value = nil
			}
			
			return value
		}
	}
}



extension UserDefaults.Item.Logger.Record {
	enum Success {
		case saving
		case loading(ItemType?)
		case deletion
		case existance(Bool)
		
		var value: String? {
			var value: String?
			
			switch self {
			case .saving:
				value = nil
			case .loading(let item):
				if let loggableItem = item as? UserDefaultsLoggable {
					value = loggableItem.userDefaultsLog
				} else if let item = item {
					value = String(describing: item)
				} else {
					value = String(describing: item)
				}
			case .deletion:
				value = nil
			case .existance(let isExist):
				value = String(isExist)
			}
			
			return value
		}
	}
}



extension UserDefaults.Item.Logger.Record {
	enum Failure {
		case error(Swift.Error)
		
		var info: String? {
			var info: String?
			
			if case Failure.error(let error) = self {
				if let loggableError = error as? UserDefaultsLoggable {
					info = "ERROR – \(loggableError.userDefaultsLog)"
				} else {
					info = "ERROR – \(error)"
				}
			}
			
			return info
		}
	}
}
