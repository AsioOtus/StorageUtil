import Foundation
import os



extension Keychain.Logger {
	enum Operation {
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
		
		enum Result {
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
		fileprivate let operation: Keychain.Logger.Operation
		fileprivate let query: [CFString: Any]
		
		init (_ operation: Keychain.Logger.Operation, _ query: [CFString: Any]) {
			self.operation = operation
			self.query = query
		}
	}
}



extension Keychain {
	public struct Logger {		
		private static var keychainIdentifier: String {
			var identifier = "Keychain"
			
			if let appIdentifier = Keychain.Settings.current.logger.appIdentifier {
				identifier = "\(appIdentifier).\(identifier)"
			}
			
			return identifier
		}
		
		static func log (_ record: Record, _ result: Operation.Result) {
			log(record.operation, result, record.query)
		}
		
		private static func log (_ operation: Operation, _ result: Operation.Result, _ query: [CFString: Any]) {
			guard Keychain.Settings.current.logger.isActive && result.level.rawValue >= Keychain.Settings.current.logger.level.rawValue else { return }
			
			var message = "\(keychainIdentifier) – \(operation.name)"
			
			if let result = result.info {
				message += " – \(result)"
			}
			
			if Keychain.Settings.current.logger.logQuery {
				message += " – \(query)"
			}
			
			os_log("%{public}@", type: result.level, message)
		}
	}
}
