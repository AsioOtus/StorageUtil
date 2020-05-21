import Foundation

extension UserDefaults {
	open class ParametricDefautableItem <ItemType: Codable, PostfixProviderType: UserDefaultsItemPostfixProvidable>: UserDefaults.DefautableItem<ItemType> {
		public func postfixedKey (_ postfixProvider: PostfixProviderType?) -> String {
			let postfixedKey = super.postfixedKey(postfixProvider)
			return postfixedKey
		}
		
		public func loadOrDefault (_ keyPostfixProvider: PostfixProviderType? = nil) -> ItemType {
			let object = super.loadOrDefault(keyPostfixProvider)
			return object
		}
		
		@discardableResult
		public func saveDefault (_ keyPostfixProvider: PostfixProviderType? = nil) -> Bool {
			let isSavingSucceeded = super.saveDefault(keyPostfixProvider)
			return isSavingSucceeded
		}
		
		@discardableResult
		public func saveDefaultIfNotExist (_ keyPostfixProvider: PostfixProviderType? = nil) -> Bool {
			let isSavingSucceeded = super.saveDefaultIfNotExist(keyPostfixProvider)
			return isSavingSucceeded
		}
	}
}
