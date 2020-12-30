import os

extension UserDefaultsUtil {
	public class Logger {
		private var userDefaultsItemTypeName: String
		
		init (_ userDefaultsItemTypeName: String) {
			self.userDefaultsItemTypeName = userDefaultsItemTypeName
		}
		
		func log<ValueType> (_ commit: Commit<ValueType>) {
			let info = Moderator.info(commit, "UserDefaultsUtil.\(self.userDefaultsItemTypeName)", UserDefaultsUtil.settings.logging)
			
			if
				let info = info,
				let loggingProvider = UserDefaultsUtil.settings.logging.loggingProvider
			{
				loggingProvider.userDefaultsUtilLog(info)
			}
		}
	}
}
