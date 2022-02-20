import Foundation

public typealias Watchable = WatchableItem

public struct WatchableItem <InnerItem: ItemProtocol>: ItemProtocol {
	private let isChangedKey: Key
	
	public let item: InnerItem
	public var isChanged: Bool { (try? storage.load(isChangedKey, Bool.self)) == true }
	
	public init (_ item: InnerItem) {
		self.item = item
		
		self.isChangedKey = item.key.add(postfix: "$isChanged")
	}
}

public extension WatchableItem {
	typealias Value = InnerItem.Value
	
	var accessQueue: DispatchQueue { item.accessQueue }
	var logger: Logger<Value> { item.logger }
	
	var storage: Storage { item.storage }
	
	func save (_ key: Key, _ value: Value) throws -> Value? {
		let value = try item.save(key, value)
		changed()
		return value
	}
	
	func load (_ key: Key) throws -> Value? {
		try item.load(key)
	}
	
	func delete (_ key: Key) throws -> Value? {
		let value = try item.delete(key)
		changed()
		return value
	}
}

public extension WatchableItem {
	var key: Key { item.key }
	
	@discardableResult
	func save (_ value: Value) -> Bool {
		let result = item.save(value)
		changed()
		return result
	}
	
	@discardableResult
	func saveIfExists (_ value: Value) -> Bool {
		let result = item.saveIfExists(value)
		changed()
		return result
	}
	
	@discardableResult
	func saveIfNotExists (_ value: Value) -> Bool {
		let result = item.saveIfNotExists(value)
		changed()
		return result
	}
	
	func load () -> Value? {
		item.load()
	}
	
	@discardableResult
	func delete () -> Bool {
		let result = item.delete()
		changed()
		return result
	}
	
	func isExists () -> Bool {
		item.isExists()
	}
}

public extension WatchableItem {
	@discardableResult
	func saveIfChanged (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save if changed")
			details.newValue = value
			defer { logger.log(details) }
			
			do {
				if isChanged {
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
	func saveIfNotChanged (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save if not changed")
			details.newValue = value
			defer { logger.log(details) }
			
			do {
				if !isChanged {
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

private extension WatchableItem {
	func changed () {
		accessQueue.sync {
			_ = try? storage.save(isChangedKey, true)
			logger.log(LogRecord<Value>.Details(operation: "changing"))
		}
	}
}

public extension ItemProtocol {
	func watchable () -> WatchableItem<Self> { .init(self) }
}
