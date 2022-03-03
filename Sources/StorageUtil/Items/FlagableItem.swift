import Foundation

public typealias Flaggable = FlagableItem

public struct FlagableItem <InnerItem: KeyedItem>: FlagableItemProtocol {
	private let flagKey: Key
	
	public let item: InnerItem
	public var flag: Bool { (try? storage.load(flagKey, Bool.self)) == true }
	
	public init (_ item: InnerItem) {
		self.item = item
		
		self.flagKey = item.key.add(postfix: "$flag")
	}
}

public extension FlagableItem {
	typealias Value = InnerItem.Value
	
	var accessQueue: DispatchQueue { item.accessQueue }
	var logger: Logger<Value> { item.logger }
	
	var storage: Storage { item.storage }
	
	func save (_ key: Key, _ value: Value) throws -> Value? { try item.save(key, value) }
	func load (_ key: Key) throws -> Value? { try item.load(key) }
	func delete (_ key: Key) throws -> Value? { try item.delete(key) }
}

public extension FlagableItem {
	var key: Key { item.key }
	
	@discardableResult func save (_ value: Value) -> Bool { item.save(value) }
	@discardableResult func saveIfExists (_ value: Value) -> Bool { item.saveIfExists(value) }
	@discardableResult func saveIfNotExists (_ value: Value) -> Bool { item.saveIfNotExists(value) }
	func load () -> Value? { item.load() }
	@discardableResult func delete () -> Bool { item.delete() }
	func isExists () -> Bool { item.isExists() }
}

public extension FlagableItem {
	func set (flag: Bool) {
		accessQueue.sync {
			_ = try? storage.save(flagKey, true)
			logger.log(LogRecord<Value>.Details(operation: "flag set to \(flag)"))
		}
	}
}

public extension FlagableItem {
	@discardableResult
	func saveWithFlag (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save with flag")
			details.newValue = value
			defer { logger.log(details) }
			
			do {
				let oldValue = try save(key, value)
				
				details.oldValue = oldValue
				details.existance = oldValue != nil
				
				_ = try storage.save(flagKey, true)
				
				return true
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
	
	@discardableResult
	func saveIfFlag (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save if flag")
			details.newValue = value
			defer { logger.log(details) }
			
			do {
				if flag {
					let oldValue = try save(key, value)
					
					details.oldValue = oldValue
					details.existance = oldValue != nil
				}
				
				return true
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
	
	@discardableResult
	func saveIfNotFlag (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save if not flag")
			details.newValue = value
			defer { logger.log(details) }
			
			do {
				if !flag {
					let oldValue = try save(key, value)
					
					details.oldValue = oldValue
					details.existance = oldValue != nil
				}
				
				return true
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
}

public extension KeyedItem {
	func flagged () -> FlagableItem<Self> { .init(self) }
}
