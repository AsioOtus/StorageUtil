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
			let commitInfo = commit.info(keychainIdentifier: "Keychain.\(self.keychainIdentifier)", enableValueLogging: enableValueLogging)
			
			if
				let commitInfo = commitInfo,
				let loggingProvider = Keychain.Settings.current.genericPasswords.logging.loggingProvider
			{
				loggingProvider.log(commitInfo)
			}
		}
	}
}
