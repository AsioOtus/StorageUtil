import Foundation

public class UserDefaultsStorage: Storage {
	public static let `default` = UserDefaultsStorage(keyPrefix: nil)
	
	public let keyPrefix: String?
	public let userDefaults: UserDefaults
	public let identificationInfo: IdentificationInfo
	
	public var logHandler: LogHandler? = nil
	
	public init (
		keyPrefix: String?,
		userDefaults: UserDefaults = .standard,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		
		self.keyPrefix = keyPrefix
		self.userDefaults = userDefaults
	}
	
	public func prefixKey (_ key: String) -> String { KeyBuilder.build(prefix: keyPrefix, key: key) }
}

extension UserDefaultsStorage {
	@discardableResult
	public func logHandler (_ logHandler: LogHandler) -> UserDefaultsStorage {
		self.logHandler = logHandler
		return self
	}
}

extension UserDefaultsStorage {
	@discardableResult
	public func save <Value: Codable> (_ key: String, _ value: Value) throws -> Value? {
		var details = LogRecord<Value>.Details(operation: "save")
		details.newValue = value
		defer {
			logHandler?.log(
				LogRecord<Value>(
					info: .init(
						keyPrefix: keyPrefix,
						key: key,
						storage: identificationInfo,
						item: nil
					),
					details: details
				)
			)
		}
		
		do {
			let prefixedKey = prefixKey(key)
			
			let oldValue = try? load(key, Value.self)
			
			details.oldValue = oldValue
			details.existance = oldValue != nil
			
			let valueJsonString = try Coder.encode(value)
			userDefaults.set(valueJsonString, forKey: prefixedKey)
			
			return oldValue
		} catch {
			details.error = UserDefaultsStorage.Error(.unexpectedError(error))
			
			throw error
		}
	}
	
	public func load <Value: Codable> (_ key: String, _ type: Value.Type) throws -> Value? {
		var details = LogRecord<Value>.Details(operation: "load")
		defer {
			logHandler?.log(
				LogRecord<Value>(
					info: .init(
						keyPrefix: keyPrefix,
						key: key,
						storage: identificationInfo,
						item: nil
					),
					details: details
				)
			)
		}
		
		do {
			let prefixedKey = prefixKey(key)
			
			guard let valueJsonString = userDefaults.string(forKey: prefixedKey) else { return nil }
			let value = try Coder.decode(valueJsonString, type)
			
			details.oldValue = value
			details.existance = true
			
			return value
		} catch {
			details.existance = false
			details.error = UserDefaultsStorage.Error(.unexpectedError(error))
			
			throw error
		}
	}
	
	public func delete <Value: Codable> (_ key: String, _ type: Value.Type) -> Value? {
		var details = LogRecord<Value>.Details(operation: "delete")
		defer {
			logHandler?.log(
				LogRecord<Value>(
					info: .init(
						keyPrefix: keyPrefix,
						key: key,
						storage: identificationInfo,
						item: nil
					),
					details: details
				)
			)
		}
		
		let prefixedKey = prefixKey(key)
		
		let oldValue = try? load(key, type)
		userDefaults.removeObject(forKey: prefixedKey)
		
		details.oldValue = oldValue
		details.existance = oldValue != nil
		
		return oldValue
	}
}
