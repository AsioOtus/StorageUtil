import Foundation

extension Keychain {
	public struct Logger {
		static func log (_ commit: Record.Commit) {
			let commitInfo = commit.info(keychainIdentifier: "Keychain")
			
			if
				let commitInfo = commitInfo,
				let loggingProvider = Keychain.Settings.current.logging.loggingProvider
			{
				loggingProvider.log(commitInfo)
			}
		}
	}
}
