import Foundation



extension UserDefaults {
	open class DefautableItem <ItemType: Codable, DefaultValueProvider: UserDefaultsDefaultValueProvider>: UserDefaults.Item<ItemType> where DefaultValueProvider.DefaultValueType == ItemType {
		public let defaultValueProvider: DefaultValueProvider
		
		public var `default`: ItemType { defaultValueProvider.defaultValue }
		
		public init (_ shortKey: String, defaultValueProvider: DefaultValueProvider, userDefaultsInstance: UserDefaults = .standard) {
			self.defaultValueProvider = defaultValueProvider
			super.init(shortKey, userDefaultsInstance)
		}
	}
}



public extension UserDefaults.DefautableItem {
	func loadOrDefault () -> ItemType {
		loadOrDefault(nil)
	}
	
	@discardableResult
	func saveDefault () -> Bool {
		saveDefault(nil)
	}
	
	@discardableResult
	func saveDefaultIfNotExist () -> Bool {
		saveDefaultIfNotExist(nil)
	}
}



internal extension UserDefaults.DefautableItem {
	func loadOrDefault (_ keyPostfixProvider: UserDefaultsItemKeyPostfixProvider? = nil) -> ItemType {
		let object = load(keyPostfixProvider)
		return object ?? defaultValueProvider.defaultValue
	}
	
	@discardableResult
	func saveDefault (_ keyPostfixProvider: UserDefaultsItemKeyPostfixProvider? = nil) -> Bool {
		let isSavingSucceeded = save(defaultValueProvider.defaultValue, keyPostfixProvider)
		return isSavingSucceeded
	}
	
	@discardableResult
	func saveDefaultIfNotExist (_ keyPostfixProvider: UserDefaultsItemKeyPostfixProvider? = nil) -> Bool {
		guard !isExists(keyPostfixProvider) else { return true }
		
		let isSavingSucceeded = saveDefault(keyPostfixProvider)
		return isSavingSucceeded
	}
}
