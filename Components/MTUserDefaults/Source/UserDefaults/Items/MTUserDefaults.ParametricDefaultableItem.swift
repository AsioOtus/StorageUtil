import Foundation

extension MTUserDefaults {
	open class ParametricDefautableItem <
		ItemType: Codable,
		DefaultValueProvider: MTUserDefaultsDefaultValueProvider,
		KeyPostfixProviderType: MTUserDefaultsItemKeyPostfixProvider
	>
		: MTUserDefaults.DefautableItem<ItemType, DefaultValueProvider>
		where DefaultValueProvider.DefaultValueType == ItemType
	{
		public func postfixedKey (_ keyPostfixProvider: KeyPostfixProviderType?) -> String {
			let postfixedKey = super.postfixedKey(keyPostfixProvider)
			return postfixedKey
		}
	}
}



extension MTUserDefaults.ParametricDefautableItem {
	@discardableResult
	public func save (_ object: ItemType, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		let isSavingSucceeded = super.save(object, keyPostfixProvider)
		return isSavingSucceeded
	}
	
	public func load (_ keyPostfixProvider: KeyPostfixProviderType) -> ItemType? {
		let object = super.load(keyPostfixProvider)
		return object
	}
	
	public func delete (_ keyPostfixProvider: KeyPostfixProviderType) {
		super.delete(keyPostfixProvider)
	}
	
	public func isExists (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		let isItemExists = super.isExists(keyPostfixProvider)
		return isItemExists
	}
}



extension MTUserDefaults.ParametricDefautableItem {
	public func loadOrDefault (_ keyPostfixProvider: KeyPostfixProviderType) -> ItemType {
		let object = super.loadOrDefault(keyPostfixProvider)
		return object
	}
	
	@discardableResult
	public func saveDefault (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		let isSavingSucceeded = super.saveDefault(keyPostfixProvider)
		return isSavingSucceeded
	}
	
	@discardableResult
	public func saveDefaultIfNotExist (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		let isSavingSucceeded = super.saveDefaultIfNotExist(keyPostfixProvider)
		return isSavingSucceeded
	}
}
