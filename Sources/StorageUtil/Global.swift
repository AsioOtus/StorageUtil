public enum Global {
	public static var storage: UserDefaultsStorage = .init(keyPrefix: nil)
	public static var logHandler: LogHandler? = nil
}
