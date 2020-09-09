import Foundation



extension MTUserDefaults {
	open class DefautableItem <ItemType: Codable, DefaultValueProvider: MTUserDefaultsDefaultValueProvider>: MTUserDefaults.Item<ItemType> where DefaultValueProvider.DefaultValueType == ItemType {
		public let defaultValueProvider: DefaultValueProvider
		private lazy var accessQueue = DispatchQueue(label: "\(Self.self).\(key).accessQueue")
		
		public var `default`: ItemType { defaultValueProvider.defaultValue }
		
		public init (_ shortKey: String, defaultValueProvider: DefaultValueProvider, userDefaultsInstance: UserDefaults = .standard) {
			self.defaultValueProvider = defaultValueProvider
			super.init(shortKey, userDefaultsInstance)
		}
	}
}



public extension MTUserDefaults.DefautableItem {
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



internal extension MTUserDefaults.DefautableItem {
	func loadOrDefault (_ keyPostfixProvider: MTUserDefaultsItemKeyPostfixProvider? = nil) -> ItemType {
		let object = load(keyPostfixProvider)
		return object ?? defaultValueProvider.defaultValue
	}
	
	@discardableResult
	func saveDefault (_ keyPostfixProvider: MTUserDefaultsItemKeyPostfixProvider? = nil) -> Bool {
		let isSavingSucceeded = save(defaultValueProvider.defaultValue, keyPostfixProvider)
		return isSavingSucceeded
	}
	
	@discardableResult
	func saveDefaultIfNotExist (_ keyPostfixProvider: MTUserDefaultsItemKeyPostfixProvider? = nil) -> Bool {
		accessQueue.sync {
			guard !isExists(keyPostfixProvider) else { return true }
			
			let isSavingSucceeded = saveDefault(keyPostfixProvider)
			return isSavingSucceeded
		}
	}
}
