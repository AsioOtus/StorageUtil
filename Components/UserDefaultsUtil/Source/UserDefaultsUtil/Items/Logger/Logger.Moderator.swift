extension UserDefaultsUtil.Logger {
	struct Moderator {
		static func info<ValueType> (_ commit: UserDefaultsUtil.Logger.Commit<ValueType>, _ userDefaultsItemTypeName: String, _ settings: UserDefaultsUtil.Settings.Logging) -> UserDefaultsUtil.Logger.Info<ValueType>? {
			guard settings.enable && commit.level.rawValue >= settings.level.rawValue else { return nil }
			
			let oldValue = settings.enableValuesLogging ? commit.oldValue : nil
			let newValue = settings.enableValuesLogging ? commit.newValue : nil
			
			let info = UserDefaultsUtil.Logger.Info(
				key: commit.key,
				operation: commit.operation,
				existance: commit.existance,
				oldValue: oldValue,
				newValue: newValue,
				error: commit.error,
				userDefaultsItemTypeName: userDefaultsItemTypeName,
				level: commit.level,
				additional: commit.additional
			)
			
			return info
		}
	}
}
