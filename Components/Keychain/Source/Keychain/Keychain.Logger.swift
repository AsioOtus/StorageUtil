import Foundation
import os



extension Keychain.Logger {
	enum Category {
		case saving
		case loading
		case deletion
		case existance
		case clearingClass
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
		
		enum Info {
			case saving
			case loading
			case deletion
			case existance(Bool)
			case clearingClass(Keychain.Class, OSStatus)
			case clearing([Keychain.Class: OSStatus])
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
				case .clearingClass(let keychainClass, let status):
					info = "\(keychainClass.name) – \(status.log)"
				case .clearing(let result):
					info = String(describing: result.map{ ($0.name, $1.log) })
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
}



extension Keychain.Logger {
	struct Record {
		private let category: Keychain.Logger.Category
		private let query: [CFString: Any]
		
		init (_ category: Keychain.Logger.Category, _ query: [CFString: Any]) {
			self.category = category
			self.query = query
		}
		
		func log (_ info: Keychain.Logger.Category.Info) {
			Keychain.Logger.log(category, info, query)
		}
	}
}



extension Keychain {
	public struct Logger {		
		private static var keychainIdentifier: String {
			var identifier = "Keychain"
			
			if let appIdentifier = Keychain.Settings.Logger.appIdentifier {
				identifier = "\(appIdentifier).\(identifier)"
			}
			
			return identifier
		}
		
		private static func log (_ category: Category, _ info: Category.Info, _ query: [CFString: Any]) {
			guard Keychain.Settings.Logger.isActive && info.level.rawValue >= Keychain.Settings.Logger.level.rawValue else { return }
			
			var message = "\(keychainIdentifier) – \(category.name)"
			
			if let info = info.info {
				message += " – \(info)"
			}
			
			if Keychain.Settings.Logger.logQuery {
				message += " – \(query)"
			}
			
			log(message, info.level)
		}
		
		private static func log (_ message: String, _ level: OSLogType = .default) {
			os_log("%{public}@", type: level, message)
		}
	}
}
