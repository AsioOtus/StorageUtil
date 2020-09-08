import os



extension UserDefaults.Item {
	public class Logger {
		private var userDefaultsItemIdentifier: String
		
		init (_ userDefaultsIdentifier: String) {
			self.userDefaultsItemIdentifier = userDefaultsIdentifier
		}
		
		func log (_ commit: Record.Commit) {
			let commitInfo = commit.info(userDefaultsItemIdentifier: "UserDefaults.\(self.userDefaultsItemIdentifier)")
			
			if
				let commitInfo = commitInfo,
				let loggingProvider = UserDefaults.settings.items.logging.loggingProvider
			{
				loggingProvider.log(commitInfo)
			}
		}
	}
}
