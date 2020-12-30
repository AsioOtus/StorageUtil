import Foundation



extension UserDefaultsUtil {
	open class ParametricItem<ValueType: Codable, KeyPostfixProviderType: UserDefaultsUtilItemKeyPostfixProvider>: UserDefaultsUtil.Item<ValueType> {
		private lazy var logger = Logger(String(describing: Self.self))
		
		func postfixedKey (_ keyPostfixProvider: KeyPostfixProviderType?) -> String {
			let postfixedKey = super.postfixedKey(keyPostfixProvider)
			return postfixedKey
		}
		
		@discardableResult
		public func save (_ object: ValueType, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
			let (isSavingSucceeded, logCommit) = super.save(object, keyPostfixProvider)
			logger.log(logCommit)
			return isSavingSucceeded
		}
		
		public func load (_ keyPostfixProvider: KeyPostfixProviderType) -> ValueType? {
			let (value, logCommit) = super.load(keyPostfixProvider)
			logger.log(logCommit)
			return value
		}
		
		public func delete (_ keyPostfixProvider: KeyPostfixProviderType) {
			let logCommit = super.delete(keyPostfixProvider)
			logger.log(logCommit)
		}
		
		public func isExists (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
			let (isItemExists, logCommit) = super.isExists(keyPostfixProvider)
			logger.log(logCommit)
			return isItemExists
		}
	}
}
