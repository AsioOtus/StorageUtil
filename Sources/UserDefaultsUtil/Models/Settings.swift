public struct Settings {
	public static var `default` = Self(storage: UserDefaultsStorage(keyPrefix: nil), logHandler: nil)
	
	public var storage: Storage
	public var logHandler: LogHandler?
	
	public init (storage: Storage = Self.default.storage, logHandler: LogHandler? = Self.default.logHandler) {
		self.storage = storage
		self.logHandler = logHandler
	}
}
