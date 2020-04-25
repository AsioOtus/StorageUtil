import Foundation

extension UserDefaults {
	open class Item <T: Codable> {
		private let userDefaultsInstance: UserDefaults
		
		internal final var keyPrefix: String { "\(App.Constants.identifier).UserDefaults.\(String(describing: Self.self))" }
		public final let shortKey: String
		public final var key: String { "\(keyPrefix).\(shortKey)" }
		
		private func appendKeyPostfix (_ postfix: String?) -> String {
			guard let postfix = postfix, !postfix.isEmpty else { return key }
			return "\(self.key).\(postfix)"
		}
		
		public init (_ shortKey: String, _ userDefaultsInstance: UserDefaults = .standard) {
			self.shortKey = shortKey
			self.userDefaultsInstance = userDefaultsInstance
		}
	}
}



public extension UserDefaults.Item {
	@discardableResult
	final func save (_ object: T, _ keyPostfix: String? = nil) -> Bool {
		let key = appendKeyPostfix(keyPostfix)
		let isSavingSucceeded = userDefaultsInstance.save(object, key)
		
		if isSavingSucceeded {
			return true
		} else {
			return false
		}
	}
	
	final func load (_ keyPostfix: String? = nil) -> T? {
		let key = appendKeyPostfix(keyPostfix)
		let object = userDefaultsInstance.load(key, T.self)
		
		if object != nil {
			return object
		} else {
			return nil
		}
	}
	
	final func delete (_ keyPostfix: String? = nil) {
		let key = appendKeyPostfix(keyPostfix)
		userDefaultsInstance.delete(key)
	}
	
	final func isExists (_ keyPostfix: String? = nil) -> Bool {
		let key = appendKeyPostfix(keyPostfix)
		let isExists = userDefaultsInstance.isExists(key, T.self)
		return isExists
	}
}
