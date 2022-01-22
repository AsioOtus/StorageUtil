import Foundation

public typealias ParametrizableDefaultable = ParametrizableDefaultableItem

public class ParametrizableDefaultableItem <InnerItem: ParametrizableItemProtocol> {
	public let item: InnerItem
	public let defaultValue: (String) -> Value
	
	public init (_ item: InnerItem, default: @escaping (String) -> Value) {
		self.item = item
		self.defaultValue = `default`
	}
	
	public convenience init (_ item: InnerItem, default: @escaping () -> Value) {
		self.init(item, default: { _ in `default`() })
	}
	
	public convenience init (_ item: InnerItem, default: Value) {
		self.init(item, default: { _ in `default` })
	}
}

extension ParametrizableDefaultableItem: ParametrizableItemProtocol {
	public typealias Value = InnerItem.Value
	public typealias KeyPostfixProviderType = InnerItem.KeyPostfixProviderType
	
	public var key: String { item.key }
	public var storage: Storage { item.storage }
	
	public var accessQueue: DispatchQueue { item.accessQueue }
	public var logger: Logger<Value> { item.logger }
	
	public func save (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		item.save(value, keyPostfixProvider)
	}
	
	public func saveIfNotExist (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		item.saveIfNotExist(value, keyPostfixProvider)
	}
	
	public func load (_ keyPostfixProvider: KeyPostfixProviderType) -> Value? {
		item.load(keyPostfixProvider)
	}
	
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

public extension ParametrizableItemProtocol {
	func defaultable (_ default: @escaping (String) -> Value) -> ParametrizableDefaultableItem<Self> {
		.init(self, default: `default`)
	}
	
	func defaultable (_ default: @escaping () -> Value) -> ParametrizableDefaultableItem<Self> {
		.init(self, default: `default`)
	}
	
	func defaultable (_ default: Value) -> ParametrizableDefaultableItem<Self> {
		.init(self, default: `default`)
	}
}
