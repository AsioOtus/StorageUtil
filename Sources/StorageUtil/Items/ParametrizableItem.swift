import Foundation

public struct ParametrizableItem <InnerItem: KeyedItem, KeyPostfixProviderType: KeyPostfixProvider>: ParametrizableKeyedItem {
	public let item: InnerItem
	
	public init (_ item: InnerItem) {
		self.item = item
	}
}

public extension ParametrizableItem {
	typealias Value = InnerItem.Value
	
	var accessQueue: DispatchQueue { item.accessQueue }
	var logger: Logger<Value> { item.logger }
	
	var storage: Storage { item.storage }
	
	func save (_ key: Key, _ value: Value) throws -> Value? { try item.save(key, value) }
	func load (_ key: Key) throws -> Value? { try item.load(key) }
	func delete (_ key: Key) throws -> Value? { try item.delete(key) }
}

public extension ParametrizableItem {
	var key: Key { item.key }
	
	@discardableResult
	func save (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = item.key.add(postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "save")
			details.newValue = value
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				let oldValue = try save(postfixedKey, value)
				
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
	func saveIfNotExist (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = item.key.add(postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "save if not exist")
			defer { logger.log(details) }
			
			do {
				if let oldValue = try? load(postfixedKey) {
					details.oldValue = oldValue
					details.existance = true
					details.comment = "old value preserved"
					
					return true
				} else {
					details.newValue = value
					
					let oldValue = try save(postfixedKey, value)
					
					details.oldValue = oldValue
					details.existance = oldValue != nil
					details.comment = "value saved"
					
					return true
				}
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
	
	func load (_ keyPostfixProvider: KeyPostfixProviderType) -> Value? {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = item.key.add(postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "load")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				let value = try load(postfixedKey)
				
				details.oldValue = value
				details.existance = value != nil
				
				return value
			} catch {
				details.existance = false
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return nil
			}
		}
	}
	
	func delete (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = item.key.add(postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "delete")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				let value = try delete(postfixedKey)
				
				details.oldValue = value
				details.existance = value != nil
				
				return true
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				
				return false
			}
		}
	}
	
	func isExists (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = item.key.add(postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "is exists")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				let value = try load(postfixedKey)
				
				details.oldValue = value
				details.existance = value != nil
				
				return value != nil
			} catch {
				details.existance = false
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
}

public extension KeyedItem {
	func parametrized <KeyPostfixProviderType: KeyPostfixProvider> (keyPostfixProviderType: KeyPostfixProviderType.Type) -> ParametrizableItem <Self, KeyPostfixProviderType> {
		.init(self)
	}
}
