public extension Global {
	static var params = Self(storage: UserDefaultsStorage(keyPrefix: nil), logHandler: nil)
}

public struct Global {
	public var defaultStorage: Storage
	public var defaultLogHandler: LogHandler?
	
	public init (storage: Storage) {
		defaultStorage = storage
	}
	
	public init (storage: Storage, logHandler: LogHandler?) {
		defaultStorage = storage
		defaultLogHandler = logHandler
	}
}
