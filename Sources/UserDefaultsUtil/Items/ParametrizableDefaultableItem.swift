import Foundation

open class ParametrizableDefaultableItem <Value: Codable, KeyPostfixProviderType: KeyPostfixProvider>: ParametrizableItem<Value, KeyPostfixProviderType> {
	public let defaultValue: (String) -> Value
	
	public init (
		_ key: String,
		defaultValue: @escaping (String) -> Value,
		storage: Storage = DefaultInstances.storage,
		logHandler: LogHandler? = DefaultInstances.logHandler,
		queue: DispatchQueue? = nil,
		alias: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.defaultValue = defaultValue
		
		super.init(key, storage: storage, logHandler: logHandler, queue: queue, alias: alias, file: file, line: line)
	}
	
	public convenience init (
		_ key: String,
		defaultValue: @escaping () -> Value,
		storage: Storage = DefaultInstances.storage,
		logHandler: LogHandler? = DefaultInstances.logHandler,
		queue: DispatchQueue? = nil,
		alias: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init(key, defaultValue: { _ in defaultValue() }, storage: storage, logHandler: logHandler, queue: queue, alias: alias, file: file, line: line)
	}
	
	public convenience init (
		_ key: String,
		defaultValue: Value,
		storage: Storage = DefaultInstances.storage,
		logHandler: LogHandler? = DefaultInstances.logHandler,
		queue: DispatchQueue? = nil,
		alias: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init(key, defaultValue: { _ in defaultValue }, storage: storage, logHandler: logHandler, queue: queue, alias: alias, file: file, line: line)
	}
}

extension ParametrizableDefaultableItem {
	public func loadOrDefault (_ keyPostfixProvider: KeyPostfixProviderType) -> Value {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "load or default")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				if let value = try storage.load(postfixedKey, Value.self) {
					details.oldValue = value
					details.existance = true
					
					return value
				} else {
					let defaultValue = self.defaultValue(postfixedKey)
					
					details.existance = false
					details.comment = "default value used – \(defaultValue)"
					
					return defaultValue
				}
			} catch {
				let defaultValue = self.defaultValue(postfixedKey)
				
				details.existance = false
				details.error = StandardStorage.Error(.unexpectedError(error))
				details.comment = "default value used – \(defaultValue)"
				
				return defaultValue
			}
		}
	}
	
	@discardableResult
	public func saveDefault (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "save default")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				let defaultValue = self.defaultValue(postfixedKey)
				
				details.newValue = defaultValue
				
				let oldValue = try storage.save(postfixedKey, defaultValue)
				
				details.oldValue = oldValue
				details.existance = oldValue != nil
				
				return true
			} catch {
				details.error = StandardStorage.Error(.unexpectedError(error))
				return false
			}
		}
	}
	
	@discardableResult
	public func saveDefaultIfNotExist (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "save default if not exist")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				if let value = try? storage.load(postfixedKey, Value.self) {
					details.oldValue = value
					details.existance = true
					details.comment = "old value preserved"
					
					return true
				} else {
					let defaultValue = self.defaultValue(postfixedKey)
					
					details.newValue = defaultValue
					
					let oldValue = try storage.save(postfixedKey, defaultValue)
					
					details.oldValue = oldValue
					details.existance = oldValue != nil
					details.comment = "default value saved"
					
					return true
				}
			} catch {
				details.error = StandardStorage.Error(.unexpectedError(error))
				
				return false
			}
		}
	}
}
