import os



extension Keychain {
	public struct Settings { }
}



extension Keychain.Settings {
	public struct Logger {
		public static var isActive = true
		public static var logQuery = false
		public static var appIdentifier: String?
		public static var level = OSLogType.info
	}
}



extension Keychain.Settings {
	public struct GenericPasswords {
		public static var appIdentifier: String!
	}
}



extension Keychain.Settings.GenericPasswords {
	public struct Logger {
		public static var isActive = true
		public static var useKeychainIdentifier = false
		public static var logQuery = false
		public static var appIdentifier: String?
		public static var level = OSLogType.default
	}
}
