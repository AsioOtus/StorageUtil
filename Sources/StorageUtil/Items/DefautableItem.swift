import Foundation

public typealias Defaultable = DefaultableItem

public class DefaultableItem <InnerItem: ItemProtocol> {
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

extension DefaultableItem: ItemProtocol {
	public typealias Value = InnerItem.Value
	
	public var key: String { item.key }
	public var storage: Storage { item.storage }
	
	public var accessQueue: DispatchQueue { item.accessQueue }
	public var logger: Logger<Value> { item.logger }
	
	public func save (_ value: Value) -> Bool { item.save(value) }
	public func saveIfNotExists (_ value: Value) -> Bool { item.saveIfNotExists(value) }
	public func load () -> Value? { item.load() }
	public func delete () -> Bool { item.delete() }
	public func isExists () -> Bool { item.isExists() }
}

public extension DefaultableItem {
	func loadOrDefault () -> Value {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "load or default")
			defer { logger.log(details) }
			
			do {
				if let value = try storage.load(item.key, Value.self) {
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
				
				let oldValue = try storage.save(key, defaultValue)
				
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
}

public extension ItemProtocol {
	func defaultable (_ default: @escaping (String) -> Value) -> DefaultableItem<Self> {
		.init(self, default: `default`)
	}
	
	func defaultable (_ default: @escaping () -> Value) -> DefaultableItem<Self> {
		.init(self, default: `default`)
	}

	func defaultable (_ default: Value) -> DefaultableItem<Self> {
		.init(self, default: `default`)
	}
}
