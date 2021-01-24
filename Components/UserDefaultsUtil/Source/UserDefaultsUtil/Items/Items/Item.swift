import Foundation



open class Item<ValueType: Codable> {
	let logger: Logger
	
	public let userDefaultsInstance: UserDefaults
	public let accessQueue: DispatchQueue
	
	public final let baseKey: String
	public final var key: String { Self.key(baseKey) }
	
	public init (_ baseKey: String, _ userDefaultsInstance: UserDefaults = .standard, queue: DispatchQueue? = nil) {
		self.logger = Logger(String(describing: Self.self))
		
		self.baseKey = baseKey
		
		self.userDefaultsInstance = userDefaultsInstance
		self.accessQueue = queue ?? DispatchQueue(label: "\(Self.self).\(Self.key(baseKey)).accessQueue")
	}

	public final func postfixedKey (_ postfixProvider: UserDefaultsUtilItemKeyPostfixProvider?) -> String {
		guard let postfixProvider = postfixProvider else { return key }
		
		let postfix = postfixProvider.userDefaultsUtilItemPostfix.trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard !postfix.isEmpty else { return key }
		
		return "\(key).\(postfix)"
	}
	
	public static func key (_ baseKey: String) -> String {
		var key = baseKey
		
		if let keyPrefix = settings.items.itemKeyPrefixProvider?.userDefaultsUtilItemPrefix {
			key = "\(keyPrefix).\(baseKey)"
		}
		
		return key
	}
}



public extension Item {
	@discardableResult
	func save (_ object: ValueType) -> Bool {
		accessQueue.sync {
			let (isSuccess, logCommit) = save(object, nil)
			logger.log(logCommit)
			return isSuccess
		}
	}
	
	func load () -> ValueType? {
		accessQueue.sync {
			let (value, logCommit) = load(nil)
			logger.log(logCommit)
			return value
		}
	}
	
	func delete () {
		accessQueue.sync {
			let logCommit = delete(nil)
			logger.log(logCommit)
		}
	}
	
	func isExists () -> Bool {
		accessQueue.sync {
			let (existance, logCommit) = isExists(nil)
			logger.log(logCommit)
			return existance
		}
	}
}



internal extension Item {
	@discardableResult
	func save (_ value: ValueType, _ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (Bool, Logger.Commit<ValueType>) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record<ValueType>(.default, key, .save, value)
		
		do {
			let (oldValue, _) = load(keyPostfixProvider)
			let valueJsonString = try Coder.encode(value)
			userDefaultsInstance.set(valueJsonString, forKey: key)
			
			return (true, logRecord.commit(oldValue))
		} catch let error as UserDefaultsUtilError {
			return (false, logRecord.commit(error: error))
		} catch {
			return (false, logRecord.commit(error: Error.unexpectedError(error)))
		}
	}
	
	func load (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (ValueType?, Logger.Commit<ValueType>) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record<ValueType>(.default, key, .load)
		
		do {
			guard let valueJsonString = userDefaultsInstance.string(forKey: key) else { throw Error.itemNotFound }
			let value = try Coder.decode(valueJsonString, ValueType.self)
			
			return (value, logRecord.commit(value))
		} catch let error as UserDefaultsUtilError {
			return (nil, logRecord.commit(error: error))
		} catch {
			return (nil, logRecord.commit(error: Error.unexpectedError(error)))
		}
	}
	
	func delete (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> Logger.Commit<ValueType> {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record<ValueType>(.default, key, .delete)
		
		let (oldValue, _) = load(keyPostfixProvider)
		userDefaultsInstance.removeObject(forKey: key)
			
		return logRecord.commit(oldValue)
	}
	
	func isExists (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (Bool, Logger.Commit<ValueType>) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record<ValueType>(.default, key, .isExists)
		
		let (value, _) = load(keyPostfixProvider)
		let isExists = value != nil
		
		return (isExists, logRecord.commit(value))
	}
}
