public struct Logger {
	private let userDefaultsItemTypeName: String
	
	init (_ userDefaultsItemTypeName: String) {
		self.userDefaultsItemTypeName = userDefaultsItemTypeName
	}
	
	func log<ValueType> (_ commit: Commit<ValueType>) {
		let info = Moderator.info(commit, userDefaultsItemTypeName, settings.logging)
		
		if
			let info = info,
			let loggingProvider = settings.logging.loggingProvider
		{
			loggingProvider.userDefaultsUtilLog(info)
		}
	}
}
