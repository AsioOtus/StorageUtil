import os



extension UserDefaults.Item {
	public class Logger {
		private var userDefaultsIdentifier: String
		
		init (_ userDefaultsIdentifier: String) {
			self.userDefaultsIdentifier = userDefaultsIdentifier
		}
		
		func log (_ commit: Record.Commit) {
			let commitInfo = commit.info(userDefaultsIdentifier: "UserDefaults.\(self.userDefaultsIdentifier)")
			
			if
				let commitInfo = commitInfo,
				let loggingProvider = UserDefaults.Settings.current.items.logging.loggingProvider
			{
				loggingProvider.log(commitInfo)
			}
		}
	}
}
