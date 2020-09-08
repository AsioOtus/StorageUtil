extension UserDefaults.Item.Logger.Record {
	struct Commit {
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
		
		func info (userDefaultsItemIdentifier: String) -> Info? {
			guard
				UserDefaults.settings.items.logging.enable &&
				resolution.level.rawValue >= UserDefaults.settings.items.logging.level.rawValue
			else { return nil }
			
			let isExists = UserDefaults.settings.items.logging.enableValuesLogging ? resolution.isExists : nil
			let value = UserDefaults.settings.items.logging.enableValuesLogging ? self.value : nil
			
			let info = Info(
				key: record.key,
				operation: record.operation.name,
				existance: isExists,
				value: value,
				error: resolution.error,
				userDefaultsItemIdentifier: userDefaultsItemIdentifier,
				level: resolution.level
			)
			
			return info
		}
	}
}
