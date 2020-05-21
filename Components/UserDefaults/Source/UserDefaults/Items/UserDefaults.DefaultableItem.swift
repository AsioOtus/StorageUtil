import Foundation

extension UserDefaults {
	open class DefautableItem <ItemType: Codable>: UserDefaults.Item<ItemType> {		
		let defaultValue: ItemType
		
		init (_ shortKey: String, defaultValue: ItemType, userDefaultsInstance: UserDefaults = .standard) {
			self.defaultValue = defaultValue
			super.init(shortKey, userDefaultsInstance)
		}
	}
}



public extension UserDefaults.DefautableItem {
	func loadOrDefault () -> ItemType {
		let object = load()
		return object ?? defaultValue
	}
	
	@discardableResult
	func saveDefault () -> Bool {
		let isSavingSucceeded = save(defaultValue)
		return isSavingSucceeded
	}
	
	@discardableResult
	func saveDefaultIfNotExist () -> Bool {
		guard !isExists() else { return true }
		
		let isSavingSucceeded = saveDefault()
		return isSavingSucceeded
	}
}



extension UserDefaults.DefautableItem {
	func loadOrDefault (_ keyPostfixProvider: UserDefaultsItemPostfixProvidable? = nil) -> ItemType {
		let object = load(keyPostfixProvider)
		return object ?? defaultValue
	}
	
	@discardableResult
	func saveDefault (_ keyPostfixProvider: UserDefaultsItemPostfixProvidable? = nil) -> Bool {
		let isSavingSucceeded = save(defaultValue, keyPostfixProvider)
		return isSavingSucceeded
	}
	
	@discardableResult
	func saveDefaultIfNotExist (_ keyPostfixProvider: UserDefaultsItemPostfixProvidable? = nil) -> Bool {
		guard !isExists(keyPostfixProvider) else { return true }
		
		let isSavingSucceeded = saveDefault(keyPostfixProvider)
		return isSavingSucceeded
	}
}
