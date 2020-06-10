extension UserDefaults.Item.Logger.Record {
	public struct Commit {
		let record: UserDefaults.Item<ItemType>.Logger.Record
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
		
		func info (userDefaultsIdentifier: String) -> Info? {
			guard
				UserDefaults.Settings.current.items.logging.enable &&
				resolution.level.rawValue >= UserDefaults.Settings.current.items.logging.level.rawValue
			else { return nil }
			
			let userDefaultsIdentifier = UserDefaults.Settings.current.items.logging.enableUserDefaultsIdentifierLogging ? userDefaultsIdentifier : nil
			let isExists = UserDefaults.Settings.current.items.logging.enableValuesLogging ? resolution.isExists : nil
			let value = UserDefaults.Settings.current.items.logging.enableValuesLogging ? self.value : nil
			
			let info = Info(
				userDefaultsIdentifier: userDefaultsIdentifier,
				key: record.key,
				operation: record.operation.name,
				existance: isExists,
				value: value,
				error: resolution.error,
				level: resolution.level
			)
			
			return info
		}
	}
}
