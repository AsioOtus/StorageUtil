public struct Default {
	public static var storage: Storage = StandardStorage(keyPrefix: nil)
	public static var logHandler: LogHandler? = nil
	
	private init () { }
}
