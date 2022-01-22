import Foundation

public typealias Initializable = InitializableItem

public class InitializableItem <InnerItem: ItemProtocol> {
	public let item: InnerItem
	
	private let isInitializedKey: String
	public let initial: Value?
	
	public init (_ item: InnerItem, initial: Value?) {
		self.item = item
		
		self.initial = initial
		self.isInitializedKey = KeyBuilder.build(prefix: "$isInitialized", key: item.key)
	}
	
	public static func withInitialization (_ item: InnerItem, initial: Value?) -> InitializableItem {
		InitializableItem(item, initial: initial)
			.initialize()
	}
}

extension InitializableItem: ItemProtocol {
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

extension InitializableItem {
	@discardableResult
	public func initialize () -> Self {
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
	func initializable (_ initial: Value?) -> InitializableItem<Self> {
		.init(self, initial: initial)
	}
	
	func withInitialization (_ initial: Value?) -> InitializableItem<Self> {
		InitializableItem.withInitialization(self, initial: initial)
	}
}
