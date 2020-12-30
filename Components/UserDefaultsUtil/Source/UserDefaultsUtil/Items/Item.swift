import Foundation
import os.log



extension UserDefaultsUtil {
	open class Item<ValueType: Codable> {
		private lazy var logger = Logger(String(describing: Self.self))
		
		private let userDefaultsInstance: UserDefaults
		
		public final let itemKey: String
		public final var key: String {
			var key = "\(itemKey)"
			
			if let keyPrefix = UserDefaultsUtil.settings.items.itemKeyPrefixProvider?.userDefaultsUtilItemPrefix {
				key = keyPrefix + ".\(key)"
			}
			
			return key
		}
		public final func postfixedKey (_ postfixProvider: UserDefaultsUtilItemKeyPostfixProvider?) -> String {
			guard let postfixProvider = postfixProvider else { return key }
			
			let postfix = postfixProvider.userDefaultsUtilItemPostfix.trimmingCharacters(in: .whitespacesAndNewlines)
			
			guard !postfix.isEmpty else { return key }
			
			return "\(self.key).\(postfix)"
		}
		
		
		
		public init (_ itemKey: String, _ userDefaultsInstance: UserDefaults = .standard) {
			self.itemKey = itemKey
			self.userDefaultsInstance = userDefaultsInstance
		}
	}
}



public extension UserDefaultsUtil.Item {
	@discardableResult
	func save (_ object: ValueType) -> Bool {
		let (isSuccess, logCommit) = save(object, nil)
		logger.log(logCommit)
		return isSuccess
	}
	
	func load () -> ValueType? {
		let (value, logCommit) = load(nil)
		logger.log(logCommit)
		return value
	}
	
	func delete () {
		let logCommit = delete(nil)
		logger.log(logCommit)
	}
	
	func isExists () -> Bool {
		let (existance, logCommit) = isExists(nil)
		logger.log(logCommit)
		return existance
	}
}



internal extension UserDefaultsUtil.Item {
	@discardableResult
	func save (_ value: ValueType, _ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (Bool, UserDefaultsUtil.Logger.Commit<ValueType>) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = UserDefaultsUtil.Logger.Record<ValueType>(.default, key, .save, value)
		
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
	
	func load (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (ValueType?, UserDefaultsUtil.Logger.Commit<ValueType>) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = UserDefaultsUtil.Logger.Record<ValueType>(.default, key, .load)
		
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
	
	func delete (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> UserDefaultsUtil.Logger.Commit<ValueType> {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = UserDefaultsUtil.Logger.Record<ValueType>(.default, key, .delete)
		
		let (oldValue, _) = load(keyPostfixProvider)
		userDefaultsInstance.removeObject(forKey: key)
			
		return logRecord.commit(oldValue)
	}
	
	func isExists (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (Bool, UserDefaultsUtil.Logger.Commit<ValueType>) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = UserDefaultsUtil.Logger.Record<ValueType>(.default, key, .isExists)
		
		let (value, _) = load(keyPostfixProvider)
		let isExists = value != nil
		
		return (isExists, logRecord.commit(value))
	}
}
