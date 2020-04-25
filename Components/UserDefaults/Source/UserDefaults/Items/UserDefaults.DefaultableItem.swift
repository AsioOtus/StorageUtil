import Foundation

extension UserDefaults {
	open class DefautableItem <T: Codable>: UserDefaults.Item<T> {		
		let defaultValue: T
		
		public init (_ shortKey: String, defaultValue: T, userDefaultsInstance: UserDefaults = .standard) {
			self.defaultValue = defaultValue
			super.init(shortKey, userDefaultsInstance)
		}
		
		func loadOrDefault (_ keyPostfix: String? = nil) -> T {
			let object = load(keyPostfix)
			return object ?? defaultValue
		}
		
		@discardableResult
		func saveDefault (_ keyPostfix: String? = nil) -> Bool {
			let isSavingSucceeded = save(defaultValue, keyPostfix)
			return isSavingSucceeded
		}
		
		@discardableResult
		func saveDefaultIfNotExist (_ keyPostfix: String? = nil) -> Bool {
			guard !isExists(keyPostfix) else { return true }
			
			let isSavingSucceeded = saveDefault(keyPostfix)
			return isSavingSucceeded
		}
	}
}
