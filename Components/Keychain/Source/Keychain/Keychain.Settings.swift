import os



extension Keychain {
	public class Settings {
		public static var current: Settings = .default
		
		public var logger: Logger
		public let genericPasswords: GenericPasswords
		
		public init (
			logger: Logger = .default,
			genericPasswords: GenericPasswords
		) {
			self.logger = logger
			self.genericPasswords = genericPasswords
		}
		
		internal static let `default` = Settings()
		private init () {
			self.logger = .default
			self.genericPasswords = .default
		}
	}
}



extension Keychain.Settings {
	public class Logger {
		public var isActive: Bool
		public var logQuery: Bool
		public var level: OSLogType
		
		public var keychainIdentifierPrefix: String?
		
		public static let `default` = Logger()
		public init (
			isActive: Bool = true,
			logQuery: Bool = false,
			level: OSLogType = .info,
			keychainIdentifierPrefix: String? = nil
		) {
			self.isActive = isActive
			self.logQuery = logQuery
			self.level = level
			self.keychainIdentifierPrefix = keychainIdentifierPrefix
		}
	}
}


	
extension Keychain.Settings {
	public class GenericPasswords {
		public var logger: Logger
		
		public let prefixProvider: KeychainGenericPasswordsPrefixProvidable?
		
		public init (
			prefixProvider: KeychainGenericPasswordsPrefixProvidable,
			logger: Logger = .default
		) {
			self.prefixProvider = prefixProvider
			self.logger = logger
		}
		
		internal static let `default` = GenericPasswords()
		private init () {
			self.prefixProvider = nil
			self.logger = .default
		}
	}
}



extension Keychain.Settings.GenericPasswords {
	public struct Logger {
		public var isActive: Bool
		public var logKeychainIdentifier: Bool
		public var logQuery: Bool
		public var logValue: Bool
		public var level: OSLogType
		
		public var keychainIdentifierPrefix: String?
		
		public var loggerProvidable: KeychainGenericPasswordLoggerProvidable?
		
		public static let `default` = Logger()
		public init (
			isActive: Bool = true,
			logKeychainIdentifier: Bool = true,
			logQuery: Bool = false,
			logValue: Bool = false,
			level: OSLogType = .default,
			keychainIdentifierPrefix: String? = nil,
			loggerProvidable: KeychainGenericPasswordLoggerProvidable? = nil
		) {
			self.isActive = isActive
			self.logKeychainIdentifier = logKeychainIdentifier
			self.logQuery = logQuery
			self.logValue = logValue
			self.level = level
			self.keychainIdentifierPrefix = keychainIdentifierPrefix
			self.loggerProvidable = loggerProvidable
		}
	}
}
