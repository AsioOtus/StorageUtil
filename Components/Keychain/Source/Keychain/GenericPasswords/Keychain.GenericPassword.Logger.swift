import Foundation
import os



extension Keychain.GenericPassword.Logger {
	enum Category {
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
		
		enum Info {
			case saving
			case loading
			case deletion
			case existance(Bool)
			case keychainError(Keychain.Error)
			case error(Error)
			
			var info: String? {
				let info: String?
				
				switch self {
				case .saving:
					info = nil
				case .loading:
					info = nil
				case .deletion:
					info = nil
				case .existance(let isExist):
					info = String(isExist)
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
					level = .info
				case .loading:
					level = .info
				case .deletion:
					level = .info
				case .existance:
					level = .info
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
	struct Record<ItemType: Codable> {
		private let logger: Keychain.GenericPassword<ItemType>.Logger
		
		private let category: Keychain.GenericPassword<ItemType>.Logger.Category
		private let identifier: String
		private let query: [CFString: Any]
		
		init (_ category: Keychain.GenericPassword<ItemType>.Logger.Category, _ identifier: String, _ query: [CFString: Any], _ logger: Keychain.GenericPassword<ItemType>.Logger) {
			self.logger = logger
			
			self.category = category
			self.identifier = identifier
			self.query = query
		}
		
		func log (_ info: Keychain.GenericPassword<ItemType>.Logger.Category.Info) {
			logger.log(identifier, category, info, query)
		}
	}
}



extension Keychain.GenericPassword {
	class Logger {
		private var keychainIdentifier: String
		private var fullKeychainIdentifier: String {
			var identifier = keychainIdentifier
			
			if let appIdentifier = Keychain.Settings.GenericPasswords.Logger.appIdentifier {
				identifier = "\(appIdentifier).\(identifier)"
			}
			
			return identifier
		}
		
		init (_ keychainIdentifier: String) {
			self.keychainIdentifier = keychainIdentifier
		}
		
		private func log (_ identifier: String, _ category: Category, _ info: Category.Info, _ query: [CFString: Any]) {
			guard Keychain.Settings.GenericPasswords.Logger.isActive && info.level.rawValue >= Keychain.Settings.GenericPasswords.Logger.level.rawValue else { return }
			
			var message = "\(identifier) – \(category.name)"
			
			if Keychain.Settings.GenericPasswords.Logger.useKeychainIdentifier {
				message = "\(fullKeychainIdentifier) – \(message)"
			}
			
			if let info = info.info {
				message += " – \(info)"
			}
			
			if Keychain.Settings.GenericPasswords.Logger.logQuery {
				message += " – \(query)"
			}
			
			log(message, info.level)
		}
		
		private func log (_ message: String, _ level: OSLogType = .default) {
			os_log("%{public}@", type: level, message)
		}
	}
}
