public class InitializableItem <Value: Codable>: Item<Value> {
	private let isInitializedKey: String
	public let initial: Value?
	
	public init (
		_ key: String,
		initial: Value?,
		storage: Storage = Global.storage,
		logHandler: LogHandler? = Global.logHandler,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.initial = initial
		self.isInitializedKey = KeyBuilder.build(prefix: "$isInitialized", key: key)
		
		super.init(key, storage: storage, logHandler: logHandler, label: label, file: file, line: line)
		
		self.initialize()
	}
}

extension InitializableItem {
	public func initialize () {
		let isInitialized = try? storage.load(isInitializedKey, Bool.self)
		if isInitialized == nil || isInitialized == false {
			_ = try? storage.save(key, initial)
		}
		
		_ = try? storage.save(isInitializedKey, true)
	}
}
