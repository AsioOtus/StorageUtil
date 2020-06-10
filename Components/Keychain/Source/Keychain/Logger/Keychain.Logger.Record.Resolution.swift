import os.log

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