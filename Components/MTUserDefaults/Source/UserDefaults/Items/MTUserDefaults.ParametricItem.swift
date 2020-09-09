import Foundation



extension MTUserDefaults {
	open class ParametricItem<ItemType: Codable, KeyPostfixProviderType: MTUserDefaultsItemKeyPostfixProvider>: MTUserDefaults.Item<ItemType> {
		public func postfixedKey (_ keyPostfixProvider: KeyPostfixProviderType?) -> String {
			let postfixedKey = super.postfixedKey(keyPostfixProvider)
			return postfixedKey
		}
		
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
}
