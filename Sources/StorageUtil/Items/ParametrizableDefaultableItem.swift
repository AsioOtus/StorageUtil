import Foundation

open class ParametrizableDefaultableItem <Value: Codable, KeyPostfixProviderType: KeyPostfixProvider>: ParametrizableItem<Value, KeyPostfixProviderType> {
	public let defaultValue: (String) -> Value
	
	public init (
		_ key: String,
		default: @escaping (String) -> Value,
		settings: Settings = .default,
		queue: DispatchQueue? = nil,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.defaultValue = `default`
		
		super.init(key, settings: settings, queue: queue, label: label, file: file, line: line)
	}
	
	public convenience init (
		_ key: String,
		default: @escaping () -> Value,
		settings: Settings = .default,
		queue: DispatchQueue? = nil,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init(key, default: { _ in `default`() }, settings: settings, queue: queue, label: label, file: file, line: line)
	}
	
	public convenience init (
		_ key: String,
		default: Value,
		settings: Settings = .default,
		queue: DispatchQueue? = nil,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init(key, default: { _ in `default` }, settings: settings, queue: queue, label: label, file: file, line: line)
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
}
