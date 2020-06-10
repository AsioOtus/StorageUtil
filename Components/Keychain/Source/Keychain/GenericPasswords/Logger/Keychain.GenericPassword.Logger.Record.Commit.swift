extension Keychain.GenericPassword.Logger.Record {
	public struct Commit {
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
				Keychain.Settings.current.genericPasswords.logging.enable &&
				self.resolution.level.rawValue >= Keychain.Settings.current.genericPasswords.logging.level.rawValue
			else { return nil }
			
			let keychainIdentifier = Keychain.Settings.current.genericPasswords.logging.enableKeychainIdentifierLogging ? keychainIdentifier : nil
			let isExists = Keychain.Settings.current.genericPasswords.logging.enableValuesLogging && enableValueLogging ? resolution.isExists : nil
			let value = Keychain.Settings.current.genericPasswords.logging.enableValuesLogging && enableValueLogging ? self.value : nil
			let query = Keychain.Settings.current.genericPasswords.logging.enableQueryLogging ? record.query : nil
			
			let info = Info(
				keychainIdentifier: keychainIdentifier,
				identifier: record.identifier,
				operation: record.operation.name,
				existance: isExists,
				value: value,
				errorType: resolution.errorType,
				error: resolution.error,
				query: query,
				level: resolution.level
			)
			
			return info
		}
	}
}
