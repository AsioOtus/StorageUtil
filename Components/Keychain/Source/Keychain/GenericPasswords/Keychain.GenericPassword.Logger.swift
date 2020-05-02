import Foundation
import os



extension Keychain.GenericPassword.Logger {
	enum Operation {
		case saving
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
		
		enum Result {
			case saving
			case loading
			case deletion(Bool)
			case existance(Bool)
			case codingError(Keychain.GenericPassword<ItemType>.Error.Category.Coding)
			case keychainError(Keychain.Error)
			case error(Error)
			
			var info: String? {
				let info: String?
				
				switch self {
				case .saving:
					info = nil
				case .loading:
					info = nil
				case .deletion(let isExisted):
					info = "Existed – \(isExisted)"
				case .existance(let isExist):
					info = String(isExist)
				case .codingError(let error):
					info = "ERROR – \(error)"
				case .keychainError(let error):
					info = "ERROR – \(error.log)"
				case .error(let error):
					info = "ERROR – \(String(describing: error))"
				}
				
				return info
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
				case .codingError:
					level = .error
				case .keychainError:
					level = .error
				case .error:
					level = .error
				}
				
				return level
			}
		}
	}
}



extension Keychain.GenericPassword.Logger {
	struct Record {
		fileprivate let operation: Keychain.GenericPassword<ItemType>.Logger.Operation
		fileprivate let identifier: String
		fileprivate let query: [CFString: Any]
		
		init (_ operation: Keychain.GenericPassword<ItemType>.Logger.Operation, _ identifier: String, _ query: [CFString: Any]) {
			self.operation = operation
			self.identifier = identifier
			self.query = query
		}
	}
}



extension Keychain.GenericPassword {
	class Logger {
		private var keychainIdentifier: String
		private var fullKeychainIdentifier: String {
			var identifier = keychainIdentifier
			
			if let appIdentifier = Keychain.Settings.current.genericPasswords.logger.appIdentifier {
				identifier = "\(appIdentifier).\(identifier)"
			}
			
			return identifier
		}
		
		init (_ keychainIdentifier: String) {
			self.keychainIdentifier = keychainIdentifier
		}
		
		func log (_ record: Record, _ result: Operation.Result) {
			log(record.operation, result, record.identifier, record.query)
		}
		
		private func log (_ operation: Operation, _ info: Operation.Result, _ identifier: String, _ query: [CFString: Any]) {
			guard Keychain.Settings.current.genericPasswords.logger.isActive && info.level.rawValue >= Keychain.Settings.current.genericPasswords.logger.level.rawValue else { return }
			
			var message = "\(identifier) – \(operation.name)"
			
			if Keychain.Settings.current.genericPasswords.logger.logKeychainIdentifier {
				message = "\(fullKeychainIdentifier) – \(message)"
			}
			
			if let info = info.info {
				message += " – \(info)"
			}
			
			if Keychain.Settings.current.genericPasswords.logger.logQuery {
				message += " – \(query)"
			}
			
			os_log("%{public}@", type: info.level, message)
		}
	}
}
