import Foundation

public typealias ParametrizableDefaultable = ParametrizableDefaultableItem

public struct ParametrizableDefaultableItem <InnerItem: ParametrizableKeyedItem> {
	public let item: InnerItem
	public let defaultValue: (Key) -> Value
	
	public init (_ item: InnerItem, default: @escaping (Key) -> Value) {
		self.item = item
		self.defaultValue = `default`
	}
	
	public init (_ item: InnerItem, default: @escaping () -> Value) {
		self.init(item, default: { _ in `default`() })
	}
	
	public init (_ item: InnerItem, default: Value) {
		self.init(item, default: { _ in `default` })
	}
}

public extension ParametrizableDefaultableItem {
	typealias Value = InnerItem.Value
	
	var accessQueue: DispatchQueue { item.accessQueue }
	var logger: Logger<Value> { item.logger }
	
	var storage: Storage { item.storage }
	
	func save (_ key: Key, _ value: Value) throws -> Value? { try item.save(key, value) }
	func load (_ key: Key) throws -> Value? { try item.load(key) }
	func delete (_ key: Key) throws -> Value? { try item.delete(key) }
}

extension ParametrizableDefaultableItem: ParametrizableKeyedItem {
	public typealias KeyPostfixProviderType = InnerItem.KeyPostfixProviderType
	
	public var key: Key { item.key }
	
	@discardableResult
	public func save (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		item.save(value, keyPostfixProvider)
	}
	
	@discardableResult
	public func saveIfNotExist (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		item.saveIfNotExist(value, keyPostfixProvider)
	}
	
	public func load (_ keyPostfixProvider: KeyPostfixProviderType) -> Value? {
		item.load(keyPostfixProvider)
	}
	
	@discardableResult 
	public func delete (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		item.delete(keyPostfixProvider)
	}
	
	public func isExists (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		item.isExists(keyPostfixProvider)
	}
}

extension ParametrizableDefaultableItem {
	public func loadOrDefault (_ keyPostfixProvider: KeyPostfixProviderType) -> Value {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = item.key.add(postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "load or default")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				if let value = try load(postfixedKey) {
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
			let postfixedKey = item.key.add(postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "save default")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				let defaultValue = self.defaultValue(postfixedKey)
				
				details.newValue = defaultValue
				
				let oldValue = try save(postfixedKey, defaultValue)
				
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
			let postfixedKey = item.key.add(postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "save default if not exist")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				if let value = try? load(postfixedKey) {
					details.oldValue = value
					details.existance = true
					details.comment = "old value preserved"
					
					return true
				} else {
					let defaultValue = self.defaultValue(postfixedKey)
					
					details.newValue = defaultValue
					
					let oldValue = try save(postfixedKey, defaultValue)
					
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

public extension ParametrizableKeyedItem {
	func `default` (_ default: @escaping (Key) -> Value) -> ParametrizableDefaultableItem<Self> {
		.init(self, default: `default`)
	}
	
	func `default` (_ default: @escaping () -> Value) -> ParametrizableDefaultableItem<Self> {
		.init(self, default: `default`)
	}
	
	func `default` (_ default: Value) -> ParametrizableDefaultableItem<Self> {
		.init(self, default: `default`)
	}
}
