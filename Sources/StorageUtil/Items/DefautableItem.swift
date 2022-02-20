import Foundation

public typealias Defaultable = DefaultableItem

public struct DefaultableItem <InnerItem: ItemProtocol>: DefaultableItemProtocol {
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

public extension DefaultableItem {
	typealias Value = InnerItem.Value
	
	var accessQueue: DispatchQueue { item.accessQueue }
	var logger: Logger<Value> { item.logger }
	
	var storage: Storage { item.storage }
	
	func save (_ key: Key, _ value: Value) throws -> Value? { try item.save(key, value) }
	func load (_ key: Key) throws -> Value? { try item.load(key) }
	func delete (_ key: Key) throws -> Value? { try item.delete(key) }
}

public extension DefaultableItem {
	var key: Key { item.key }
	
	@discardableResult func save (_ value: Value) -> Bool { item.save(value) }
	@discardableResult func saveIfExists (_ value: Value) -> Bool { item.saveIfExists(value) }
	@discardableResult func saveIfNotExists (_ value: Value) -> Bool { item.saveIfNotExists(value) }
	func load () -> Value? { item.load() }
	@discardableResult func delete () -> Bool { item.delete() }
	func isExists () -> Bool { item.isExists() }
}

public extension DefaultableItem {
	func loadOrDefault () -> Value {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "load or default")
			defer { logger.log(details) }
			
			do {
				if let value = try load(item.key) {
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				details.comment = "default value used – \(defaultValue)"
				
				return defaultValue
			}
		}
	}
	
	@discardableResult
	func saveDefault () -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save default")
			defer { logger.log(details) }
			
			do {
				let defaultValue = self.defaultValue(key)
				
				details.newValue = defaultValue
				
				let oldValue = try save(key, defaultValue)
				
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
	func saveDefaultIfNotExist () -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save default if not exist")
			defer { logger.log(details) }
			
			do {
				if let value = try? load(key) {
					details.oldValue = value
					details.existance = true
					details.comment = "old value preserved"
					
					return true
				} else {
					let defaultValue = self.defaultValue(key)
					
					details.newValue = defaultValue
					
					let oldValue = try save(key, defaultValue)
					
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

public extension ItemProtocol {
	func `default` (_ default: @escaping (Key) -> Value) -> DefaultableItem<Self> {
		.init(self, default: `default`)
	}
	
	func `default` (_ default: @escaping () -> Value) -> DefaultableItem<Self> {
		.init(self, default: `default`)
	}

	func `default` (_ default: Value) -> DefaultableItem<Self> {
		.init(self, default: `default`)
	}
}
