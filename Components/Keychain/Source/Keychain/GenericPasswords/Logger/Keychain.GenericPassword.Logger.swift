import Foundation
import os



extension Keychain.GenericPassword {
	class Logger {
		private var keychainIdentifier: String
		private var fullKeychainIdentifier: String {
			var identifier = keychainIdentifier
			
			if let prefix = Keychain.Settings.current.genericPasswords.logger.keychainIdentifierPrefix {
				identifier = "\(prefix).\(identifier)"
			}
			
			return identifier
		}
		
		init (_ keychainIdentifier: String) {
			self.keychainIdentifier = keychainIdentifier
		}
		
		func log (_ recordInfo: Record.Info) {
			guard
				Keychain.Settings.current.genericPasswords.logger.isActive &&
				recordInfo.level.rawValue >= Keychain.Settings.current.genericPasswords.logger.level.rawValue
			else { return }
			
			var message = "\(recordInfo.identifier) – \(recordInfo.operation)"
			
			if Keychain.Settings.current.genericPasswords.logger.logKeychainIdentifier {
				message = "\(fullKeychainIdentifier) – \(message)"
			}
			
			if Keychain.Settings.current.genericPasswords.logger.logValue, let value = recordInfo.value {
				message += " – \(value)"
			}
			
			if let errorInfo = recordInfo.error {
				message += " – \(errorInfo)"
			}
			
			if Keychain.Settings.current.genericPasswords.logger.logQuery {
				message += " – \(recordInfo.query)"
			}
			
			os_log("%{public}@", type: recordInfo.level, message)
		}
	}
}
