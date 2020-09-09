import Foundation

extension Keychain.GenericPassword {
	public class Logger {
		private let keychainIdentifier: String
		private let enableValueLogging: Bool
		
		init (_ keychainIdentifier: String, _ enableValueLogging: Bool) {
			self.keychainIdentifier = "Keychain.\(keychainIdentifier)"
			self.enableValueLogging = enableValueLogging
		}
		
		func log (_ commit: Record.Commit) {
			let commitInfo = commit.info(keychainIdentifier: keychainIdentifier, enableValueLogging: enableValueLogging)
			
			if
				let commitInfo = commitInfo,
				let loggingProvider = Keychain.settings.genericPasswords.logging.loggingProvider
			{
				loggingProvider.log(commitInfo)
			}
		}
	}
}
