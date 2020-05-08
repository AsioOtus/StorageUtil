import Foundation



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
			
			
			let keychainIdentifier = Keychain.Settings.current.genericPasswords.logger.logKeychainIdentifier ? fullKeychainIdentifier : nil
			let value = Keychain.Settings.current.genericPasswords.logger.logValue ? recordInfo.value : nil
			let query = Keychain.Settings.current.genericPasswords.logger.logQuery ? recordInfo.query : nil
			
			let logRecordInfo = Keychain.GenericPasswordLogRecordInfo(
				keychainIdentifier: keychainIdentifier,
				identifier: recordInfo.identifier,
				operation: recordInfo.operation,
				value: value,
				query: query,
				error: recordInfo.error,
				level: recordInfo.level
			)
			
			log(logRecordInfo)
		}
		
		private func log (_ logRecordInfo: Keychain.GenericPasswordLogRecordInfo) {
			if let loggerProvider = Keychain.Settings.current.genericPasswords.logger.loggerProvidable {
				loggerProvider.log(logRecordInfo)
			}
		}
	}
}
