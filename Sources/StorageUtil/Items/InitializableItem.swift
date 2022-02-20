import Foundation

public typealias Initializable = InitializableItem

public struct InitializableItem <InnerItem: ItemProtocol>: InitializableItemProtocol {
	private let isInitializedKey: Key
	
	public let item: InnerItem
	public let initial: Value?
	
	public init (_ item: InnerItem, initial: Value?) {
		self.item = item
		
		self.initial = initial
		self.isInitializedKey = item.key.add(prefix: "$isInitialized")
	}
}

public extension InitializableItem {
	typealias Value = InnerItem.Value
	
	var accessQueue: DispatchQueue { item.accessQueue }
	var logger: Logger<Value> { item.logger }
	
	var storage: Storage { item.storage }
	
	func save (_ key: Key, _ value: Value) throws -> Value? { try item.save(key, value) }
	func load (_ key: Key) throws -> Value? { try item.load(key) }
	func delete (_ key: Key) throws -> Value? { try item.delete(key) }
}

public extension InitializableItem {
	var key: Key { item.key }
	
	@discardableResult func save (_ value: Value) -> Bool { item.save(value) }
	@discardableResult func saveIfExists (_ value: Value) -> Bool { item.saveIfExists(value) }
	@discardableResult func saveIfNotExists (_ value: Value) -> Bool { item.saveIfNotExists(value) }
	func load () -> Value? { item.load() }
	@discardableResult func delete () -> Bool { item.delete() }
	func isExists () -> Bool { item.isExists() }
}

public extension InitializableItem {
	static func withInitialization (_ item: InnerItem, initial: Value?) -> InitializableItem {
		InitializableItem(item, initial: initial).initialize()
	}
	
	@discardableResult
	func initialize () -> Self {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "initialization")
			defer { logger.log(details) }
			
			let isInitialized = try? storage.load(isInitializedKey, Bool.self)
			
			if isInitialized == nil || isInitialized == false {
				_ = try? storage.save(key, initial)
				details.comment = "completed"
			} else {
				_ = try? storage.save(isInitializedKey, true)
				details.comment = "already initialized"
			}
		}
		
		return self
	}
}

public extension ItemProtocol {
	func initial (_ initial: Value?) -> InitializableItem<Self> {
		.withInitialization(self, initial: initial)
	}
}
