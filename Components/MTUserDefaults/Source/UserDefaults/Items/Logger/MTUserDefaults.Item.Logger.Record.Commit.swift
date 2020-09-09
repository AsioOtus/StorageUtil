extension MTUserDefaults.Item.Logger.Record {
	struct Commit {
		let record: MTUserDefaults.Item<ItemType>.Logger.Record
		let resolution: Resolution
		
		private var value: ItemType? {
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
				MTUserDefaults.settings.items.logging.enable &&
				resolution.level.rawValue >= MTUserDefaults.settings.items.logging.level.rawValue
			else { return nil }
			
			let isExists = MTUserDefaults.settings.items.logging.enableValuesLogging ? resolution.isExists : nil
			let value = MTUserDefaults.settings.items.logging.enableValuesLogging ? self.value : nil
			
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
