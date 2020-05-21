import Foundation

extension Keychain.GenericPassword {
	public class Logger {
		private let keychainIdentifier: String
		private let enableValueLogging: Bool
		
		init (_ keychainIdentifier: String, _ enableValueLogging: Bool) {
			self.keychainIdentifier = keychainIdentifier
			self.enableValueLogging = enableValueLogging
		}
		
		func log (_ commit: Record.Commit) {
			let recordInfo = convert(commit)
			
			if let recordInfo = recordInfo {
				log(recordInfo)
			}
		}
		
		private func convert (_ commit: Record.Commit) -> Keychain.GenericPassword<ItemType>.Logger.Record.Info? {
			guard
				Keychain.Settings.current.genericPasswords.logging.enable &&
				commit.resolving.level.rawValue >= Keychain.Settings.current.genericPasswords.logging.level.rawValue
			else { return nil }
			
			let keychainIdentifier = Keychain.Settings.current.genericPasswords.logging.enableKeychainIdentifierLogging ? "Keychain.\(self.keychainIdentifier)" : nil
			let isExists = Keychain.Settings.current.genericPasswords.logging.enableValuesLogging && enableValueLogging ? commit.resolving.isExists : nil
			let value = Keychain.Settings.current.genericPasswords.logging.enableValuesLogging && enableValueLogging ? commit.value : nil
			let query = Keychain.Settings.current.genericPasswords.logging.enableQueryLogging ? commit.query : nil
			
			let info = Keychain.GenericPassword.Logger.Record.Info(
				keychainIdentifier: keychainIdentifier,
				identifier: commit.identifier,
				operation: commit.operation.name,
				existance: isExists,
				value: value,
				errorType: commit.resolving.errorType,
				error: commit.resolving.error,
				query: query,
				level: commit.resolving.level
			)
			
			return info
		}
		
		private func log (_ recordInfo: Keychain.GenericPassword<ItemType>.Logger.Record.Info) {
			if let loggingProvider = Keychain.Settings.current.genericPasswords.logging.loggingProvider {
				loggingProvider.log(recordInfo)
			}
		}
	}
}
