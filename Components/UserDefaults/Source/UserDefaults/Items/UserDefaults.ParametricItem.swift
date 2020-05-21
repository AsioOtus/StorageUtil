import Foundation



extension UserDefaults {
	open class ParametricItem<ItemType: Codable, PostfixProviderType: UserDefaultsItemPostfixProvidable>: UserDefaults.Item<ItemType> {
		public func postfixedKey (_ postfixProvider: PostfixProviderType?) -> String {
			let postfixedKey = super.postfixedKey(postfixProvider)
			return postfixedKey
		}
		
		@discardableResult
		public func save (_ object: ItemType, _ keyPostfixProvider: PostfixProviderType? = nil) -> Bool {
			let isSavingSucceeded = super.save(object, keyPostfixProvider)
			return isSavingSucceeded
		}
		
		public func load (_ keyPostfixProvider: PostfixProviderType? = nil) -> ItemType? {
			let object = super.load(keyPostfixProvider)
			return object
		}
		
		public func delete (_ keyPostfixProvider: PostfixProviderType? = nil) {
			super.delete(keyPostfixProvider)
		}
		
		public func isExists (_ keyPostfixProvider: PostfixProviderType? = nil) -> Bool {
			let isItemExists = super.isExists(keyPostfixProvider)
			return isItemExists
		}
	}
}
