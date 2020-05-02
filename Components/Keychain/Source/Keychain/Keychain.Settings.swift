import os



extension Keychain {
	public class Settings {
		public static var current: Settings = .default
		
		public var logger: Logger
		public let genericPasswords: GenericPasswords
		
		internal static let `default` = Settings()
		public init (
			logger: Logger = .default,
			genericPasswords: GenericPasswords
		) {
			self.logger = logger
			self.genericPasswords = genericPasswords
		}
		
		private init () {
			self.logger = .default
			self.genericPasswords = .default
		}
	}
}



extension Keychain.Settings {
	public class Logger {
		public var isActive = true
		public var logQuery = false
		public var level = OSLogType.info
		public var appIdentifier: String?
		
		public static let `default` = Logger()
		public init (
			isActive: Bool = true,
			logQuery: Bool = false,
			level: OSLogType = .info,
			appIdentifier: String? = nil
		) {
			self.isActive = isActive
			self.logQuery = logQuery
			self.level = level
			self.appIdentifier = appIdentifier
		}
	}
}


	
extension Keychain.Settings {
	public class GenericPasswords {
		public var logger: Logger
		
		public let prefixProvider: KeychainPrefixProvidable?
		
		internal static let `default` = GenericPasswords()
		public init (
			prefixProvider: KeychainPrefixProvidable,
			logger: Logger = .default
		) {
			self.prefixProvider = prefixProvider
			self.logger = logger
		}
		
		private init () {
			self.prefixProvider = nil
			self.logger = .default
		}
		
		public struct Logger {
			public var isActive = true
			public var logKeychainIdentifier = false
			public var logQuery = false
			public var level = OSLogType.default
			
			public var appIdentifier: String?
			
			public static let `default` = Logger()
			public init (
				isActive: Bool = true,
				logKeychainIdentifier: Bool = false,
				logQuery: Bool = false,
				level: OSLogType = .default,
				appIdentifier: String? = nil
			) {
				self.isActive = isActive
				self.logKeychainIdentifier = logKeychainIdentifier
				self.logQuery = logQuery
				self.level = level
				self.appIdentifier = appIdentifier
			}
		}
	}
}
