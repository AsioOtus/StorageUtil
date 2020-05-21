import os



extension UserDefaults.Item {
	class Logger {
		private var userDefaultsIdentifier: String
		private var fullUserDefaultsIdentifier: String {
			var identifier = userDefaultsIdentifier
			
			if let prefix = UserDefaults.Settings.current.items.logger.userDefaultsIdentifierPrefix {
				identifier = "\(prefix).\(identifier)"
			}
			
			return identifier
		}
		
		init (_ userDefaultsIdentifier: String) {
			self.userDefaultsIdentifier = userDefaultsIdentifier
		}
		
		func log (_ recordInfo: Record.Info) {
			guard
				UserDefaults.Settings.current.items.logger.isActive &&
					recordInfo.level.rawValue >= UserDefaults.Settings.current.items.logger.level.rawValue
				else { return }
			
			
			let keychainIdentifier = UserDefaults.Settings.current.items.logger.logUserDefaultsIdentifier ? fullUserDefaultsIdentifier : nil
			let value = UserDefaults.Settings.current.items.logger.logValue ? recordInfo.value : nil
			
			let logRecordInfo = UserDefaults.ItemLogRecordInfo(
				userDefaultsIdentifier: keychainIdentifier,
				key: recordInfo.identifier,
				operation: recordInfo.operation,
				value: value,
				error: recordInfo.error,
				level: recordInfo.level
			)
			
			log(logRecordInfo)
		}
		
		private func log (_ logRecordInfo: UserDefaults.ItemLogRecordInfo) {
			if UserDefaults.Settings.current.items.logger.useOsLogger {
				os_log("%{public}@", type: logRecordInfo.level, logRecordInfo.message)
			} else if let loggerProvider = UserDefaults.Settings.current.items.logger.loggerProvidable {
				loggerProvider.log(logRecordInfo)
			}
		}
	}
}
