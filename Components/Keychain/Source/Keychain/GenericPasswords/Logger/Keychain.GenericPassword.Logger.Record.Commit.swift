extension Keychain.GenericPassword.Logger.Record {
	struct Commit {
		let record: Keychain.GenericPassword<ItemType>.Logger.Record
		let resolution: Resolution
		
		var value: ItemType? {
			let value: ItemType?
			
			if let operationValue = record.operation.value {
				value = operationValue
			} else if let resolutionValue = resolution.value {
				value = resolutionValue
			} else {
				value = nil
			}
			
			return value
		}
		
		func info (keychainIdentifier: String, enableValueLogging: Bool) -> Info? {
			guard
				Keychain.settings.genericPasswords.logging.enable &&
				self.resolution.level.rawValue >= Keychain.settings.genericPasswords.logging.level.rawValue
			else { return nil }
			
			let isExists = Keychain.settings.genericPasswords.logging.enableValuesLogging && enableValueLogging ? resolution.isExists : nil
			let value = Keychain.settings.genericPasswords.logging.enableValuesLogging && enableValueLogging ? self.value : nil
			let query = Keychain.settings.genericPasswords.logging.enableQueryLogging ? record.query : nil
			
			let info = Info(
				identifier: record.identifier,
				operation: record.operation.name,
				existance: isExists,
				value: value,
				errorType: resolution.errorType,
				error: resolution.error,
				query: query,
				keychainIdentifier: keychainIdentifier,
				level: resolution.level
			)
			
			return info
		}
	}
}
