import Foundation

open class ParametrizableDefaultableItem <Value: Codable, KeyPostfixProviderType: KeyPostfixProvider>: ParametrizableItem<Value, KeyPostfixProviderType> {
	public let defaultValue: (String) -> Value
	
	public init (
		_ key: String,
		defaultValue: @escaping (String) -> Value,
		storage: Storage = DefaultInstances.storage,
		logHandler: LogHandler? = DefaultInstances.logHandler,
		queue: DispatchQueue? = nil,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.defaultValue = defaultValue
		
		let uuid = UUID()
		let label = label ?? LabelBuilder.build(String(describing: Self.self), file, line, uuid)
		super.init(key, storage: storage, logHandler: logHandler, queue: queue, label: label)
	}
	
	public convenience init (
		_ key: String,
		defaultValue: @escaping () -> Value,
		storage: Storage = DefaultInstances.storage,
		logHandler: LogHandler? = DefaultInstances.logHandler,
		queue: DispatchQueue? = nil,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.init(key, defaultValue: { _ in defaultValue() }, storage: storage, logHandler: logHandler, queue: queue, label: label, file: file, line: line)
	}
	
	public convenience init (
		_ key: String,
		defaultValue: Value,
		storage: Storage = DefaultInstances.storage,
		logHandler: LogHandler? = DefaultInstances.logHandler,
		queue: DispatchQueue? = nil,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.init(key, defaultValue: { _ in defaultValue }, storage: storage, logHandler: logHandler, queue: queue, label: label, file: file, line: line)
	}
}

extension ParametrizableDefaultableItem {
	public func loadOrDefault (_ keyPostfixProvider: KeyPostfixProviderType) -> Value {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "load or default")
			details.keyPostfix = keyPostfix
			
			do {
				if let value = try storage.load(postfixedKey, Value.self) {
					details.oldValue = value
					details.existance = true
					logger.log(details)
					
					return value
				} else {
					let defaultValue = self.defaultValue(postfixedKey)
					
					details.existance = false
					details.comment = "default value used – \(defaultValue)"
					logger.log(details)
					
					return defaultValue
				}
			} catch {
				let defaultValue = self.defaultValue(postfixedKey)
				
				details.existance = false
				details.error = StandardStorage.Error(.unexpectedError(error))
				details.comment = "default value used – \(defaultValue)"
				logger.log(details)
				
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
			
			do {
				let defaultValue = self.defaultValue(postfixedKey)
				
				details.newValue = defaultValue
				
				let oldValue = try storage.save(postfixedKey, defaultValue)
				
				details.oldValue = oldValue
				details.existance = oldValue != nil
				logger.log(details)
				
				return true
			} catch {
				details.error = StandardStorage.Error(.unexpectedError(error))
				logger.log(details)
				
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
			
			do {
				if let value = try? storage.load(postfixedKey, Value.self) {
					details.oldValue = value
					details.existance = true
					details.comment = "old value preserved"
					logger.log(details)
					
					return true
				} else {
					let defaultValue = self.defaultValue(postfixedKey)
					
					details.newValue = defaultValue
					
					let oldValue = try storage.save(postfixedKey, defaultValue)
					
					details.oldValue = oldValue
					details.existance = oldValue != nil
					details.comment = "default value saved"
					logger.log(details)
					
					return true
				}
			} catch {
				details.error = StandardStorage.Error(.unexpectedError(error))
				logger.log(details)
				
				return false
			}
		}
	}
}
