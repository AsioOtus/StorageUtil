extension Keychain.Logger.Record {
	public struct Commit {
		let record: Keychain.Logger.Record
		let resolution: Resolution
		
		var value: AnyObject? {
			let value: AnyObject?
			
			if let operationValue = record.operation.value {
				value = operationValue as AnyObject
			} else if let resolutionValue = resolution.value {
				value = resolutionValue
			} else {
				value = nil
			}
			
			return value
		}
		
		func info (keychainIdentifier: String) -> Info? {
			guard
				Keychain.Settings.current.logging.enable &&
				resolution.level.rawValue >= Keychain.Settings.current.logging.level.rawValue
			else { return nil }
			
			let keychainIdentifier = Keychain.Settings.current.logging.enableKeychainIdentifierLogging ? keychainIdentifier : nil
			let isExists = Keychain.Settings.current.logging.enableValuesLogging ? resolution.isExists : nil
			let value = Keychain.Settings.current.logging.enableValuesLogging ? self.value : nil
			let query = Keychain.Settings.current.logging.enableQueryLogging ? record.query : nil
			
			let info = Info(
				keychainIdentifier: keychainIdentifier,
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
