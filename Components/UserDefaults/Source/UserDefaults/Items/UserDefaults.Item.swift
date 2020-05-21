import Foundation

extension UserDefaults {
	open class Item <ItemType: Codable> {
		private lazy var logger = Logger("UserDefaults.\(String(describing: Self.self))")
		
		private let userDefaultsInstance: UserDefaults
		
		
		
		final var keyPrefix: String {
			guard let prefixProvider = UserDefaults.Settings.current.items.prefixProvider else { fatalError("UserDefaults.Settings.current.items.prefixProvider is nil") }
			let prefix = prefixProvider.userDefaultsItemPrefix
			return prefix
		}
		public final let itemKey: String
		public final var key: String { "\(keyPrefix).\(itemKey)" }
		func postfixedKey (_ postfixProvider: UserDefaultsItemPostfixProvidable?) -> String {
			guard let postfixProvider = postfixProvider else { return key }
			
			let postfix = postfixProvider.userDefaultsItemPostfix.trimmingCharacters(in: .whitespacesAndNewlines)
			
			guard !postfix.isEmpty else { return key }
			
			return "\(self.key).\(postfix)"
		}
		
		
		
		public init (_ itemKey: String, _ userDefaultsInstance: UserDefaults = .standard) {
			self.itemKey = itemKey
			self.userDefaultsInstance = userDefaultsInstance
		}
	}
}



public extension UserDefaults.Item {
	@discardableResult
	func save (_ object: ItemType) -> Bool {
		let logRecord = Logger.Record(.saving(object), key)
		
		do {
			try userDefaultsInstance.save(object, key)
			
			logger.log(logRecord.info(.saving))
			
			return true
		} catch {
			logger.log(logRecord.info(.error(error)))
			
			return false
		}
	}
	
	func load () -> ItemType? {
		let logRecord = Logger.Record(.loading, key)
		
		do {
			let object = try userDefaultsInstance.load(key, ItemType.self)
			
			logger.log(logRecord.info(.loading(object)))
			
			return object
		} catch {
			logger.log(logRecord.info(.error(error)))
			
			return nil
		}
	}
	
	func delete () {
		let logRecord = Logger.Record(.deletion, key)
		
		userDefaultsInstance.delete(key)
		
		logger.log(logRecord.info(.deletion))
	}
	
	func isExists () -> Bool {
		let logRecord = Logger.Record(.existance, key)
		
		do {
			let isExists = try userDefaultsInstance.isExists(key, ItemType.self)
			
			logger.log(logRecord.info(.existance(isExists)))
			
			return isExists
		} catch {
			logger.log(logRecord.info(.error(error)))
			
			return false
		}
	}
}



extension UserDefaults.Item {
	@discardableResult
	func save (_ object: ItemType, _ keyPostfixProvider: UserDefaultsItemPostfixProvidable? = nil) -> Bool {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record(.saving(object), key)
		
		do {
			try userDefaultsInstance.save(object, key)
			
			logger.log(logRecord.info(.saving))
			
			return true
		} catch {
			logger.log(logRecord.info(.error(error)))
			
			return false
		}
	}
	
	func load (_ keyPostfixProvider: UserDefaultsItemPostfixProvidable? = nil) -> ItemType? {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record(.loading, key)
		
		do {
			let object = try userDefaultsInstance.load(key, ItemType.self)
			
			logger.log(logRecord.info(.loading(object)))
			
			return object
		} catch {
			logger.log(logRecord.info(.error(error)))
			
			return nil
		}
	}
	
	func delete (_ keyPostfixProvider: UserDefaultsItemPostfixProvidable? = nil) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record(.deletion, key)
		
		userDefaultsInstance.delete(key)
		
		logger.log(logRecord.info(.deletion))
	}
	
	func isExists (_ keyPostfixProvider: UserDefaultsItemPostfixProvidable? = nil) -> Bool {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record(.existance, key)
		
		do {
			let isExists = try userDefaultsInstance.isExists(key, ItemType.self)
			
			logger.log(logRecord.info(.existance(isExists)))
			
			return isExists
		} catch {
			logger.log(logRecord.info(.error(error)))
			
			return false
		}
	}
}
