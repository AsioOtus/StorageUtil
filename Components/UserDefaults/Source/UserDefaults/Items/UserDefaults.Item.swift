import Foundation

extension UserDefaults {
	open class Item <ItemType: Codable> {
		private lazy var logger = Logger(String(describing: Self.self))
		
		private let userDefaultsInstance: UserDefaults
		
		
		
		final var keyPrefix: String {
			guard let prefixProvider = UserDefaults.settings.items.itemKeyPrefixProvider else { fatalError("UserDefaults.settings.items.prefixProvider is nil") }
			let prefix = prefixProvider.userDefaultsItemPrefix
			return prefix
		}
		public final let itemKey: String
		public final var key: String { "\(keyPrefix).\(itemKey)" }
		public final func postfixedKey (_ postfixProvider: UserDefaultsItemKeyPostfixProvider?) -> String {
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
		save(object, nil)
	}
	
	func load () -> ItemType? {
		load(nil)
	}
	
	func delete () {
		delete(nil)
	}
	
	func isExists () -> Bool {
		isExists(nil)
	}
}



internal extension UserDefaults.Item {
	@discardableResult
	func save (_ object: ItemType, _ keyPostfixProvider: UserDefaultsItemKeyPostfixProvider? = nil) -> Bool {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record(.saving(object), key)
		
		do {
			let data = try Self.encode(object)
			userDefaultsInstance.set(data, forKey: key)
			
			logger.log(logRecord.commit(.saving))
			
			return true
		} catch {
			logger.log(logRecord.commit(.genericError(error)))
			
			return false
		}
	}
	
	func load (_ keyPostfixProvider: UserDefaultsItemKeyPostfixProvider? = nil) -> ItemType? {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record(.loading, key)
		
		do {
			guard let data = userDefaultsInstance.data(forKey: key) else { throw Error.itemNotFound }
			let object = try Self.decode(data, ItemType.self)
			
			logger.log(logRecord.commit(.loading(object)))
			
			return object
		} catch {
			logger.log(logRecord.commit(.genericError(error)))
			
			return nil
		}
	}
	
	func delete (_ keyPostfixProvider: UserDefaultsItemKeyPostfixProvider? = nil) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record(.deletion, key)
		
		userDefaultsInstance.removeObject(forKey: key)
		
		logger.log(logRecord.commit(.deletion))
	}
	
	func isExists (_ keyPostfixProvider: UserDefaultsItemKeyPostfixProvider? = nil) -> Bool {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record(.existance, key)
		
		do {
			let object: ItemType?
			let isExists: Bool
			
			if let data = userDefaultsInstance.data(forKey: key) {
				object = try Self.decode(data, ItemType.self)
				isExists = true
			} else {
				object = nil
				isExists = false
			}
			
			logger.log(logRecord.commit(.existance(isExists, object)))
			
			return isExists
		} catch {
			logger.log(logRecord.commit(.genericError(error)))
			
			return false
		}
	}
}



private extension UserDefaults.Item {
	static func encode <T: Encodable> (_ object: T) throws -> Data {
		do {
			let data = try JSONEncoder().encode(object)
			return data
		} catch {
			throw Error.encodingFailed(error)
		}
	}
	
	static func decode <T: Decodable> (_ data: Data, _ type: T.Type) throws -> T {
		do {
			let data = try JSONDecoder().decode(type, from: data)
			return data
		} catch {
			throw Error.decodingFailed(error)
		}
	}
}
