import Foundation

open class DefaultableItem <Value: Codable>: Item<Value> {
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

extension DefaultableItem {
	public func loadOrDefault () -> Value {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "load or default")
			defer { logger.log(details) }
			
			do {
				if let value = try storage.load(key, Value.self) {
					details.oldValue = value
					details.existance = true
					
					return value
				} else {
					let defaultValue = self.defaultValue(key)
					
					details.existance = false
					details.comment = "default value used – \(defaultValue)"
					
					return defaultValue
				}
			} catch {
				let defaultValue = self.defaultValue(key)
				
				details.existance = false
				details.error = StandardStorage.Error(.unexpectedError(error))
				details.comment = "default value used – \(defaultValue)"
				
				return defaultValue
			}
		}
	}
	
	@discardableResult
	public func saveDefault () -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save default")
			defer { logger.log(details) }
			
			do {
				let defaultValue = self.defaultValue(key)
				
				details.newValue = defaultValue
				
				let oldValue = try storage.save(key, defaultValue)
				
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
	public func saveDefaultIfNotExist () -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save default if not exist")
			defer { logger.log(details) }
			
			do {
				if let value = try? storage.load(key, Value.self) {
					details.oldValue = value
					details.existance = true
					details.comment = "old value preserved"
					
					return true
				} else {
					let defaultValue = self.defaultValue(key)
					
					details.newValue = defaultValue
					
					let oldValue = try storage.save(key, defaultValue)
					
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
