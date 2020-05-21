import Foundation
import os



extension UserDefaults {
	public struct Settings {
		public static var current: Settings = .default
		
		public let items: Items
		
		public init (
			items: Items
		) {
			self.items = items
		}
		
		public static let `default` = Settings()
		private init () {
			self.items = .default
		}
	}
}



extension UserDefaults.Settings {
	public struct Items {
		public var logger: Logger
		
		public let prefixProvider: UserDefaultsItemPrefixProvidable?
		
		public init (
			prefixProvider: UserDefaultsItemPrefixProvidable,
			logger: Logger = .default
		) {
			self.prefixProvider = prefixProvider
			self.logger = logger
		}
		
		internal static let `default` = Items()
		private init () {
			self.prefixProvider = nil
			self.logger = .default
		}
	}
}



extension UserDefaults.Settings.Items {
	public struct Logger {
		public var isActive: Bool
		public var logUserDefaultsIdentifier: Bool
		public var logValue: Bool
		public var level: OSLogType
		
		public var userDefaultsIdentifierPrefix: String?
		
		public var useOsLogger: Bool
		public var loggerProvidable: UserDefaultsLoggerProvidable?
		
		public static let `default` = Logger()
		public init (
			isActive: Bool = true,
			logUserDefaultsIdentifier: Bool = true,
			logValue: Bool = false,
			level: OSLogType = .default,
			userDefaultsIdentifierPrefix: String? = nil,
			useOsLogger: Bool = false,
			loggerProvidable: UserDefaultsLoggerProvidable? = nil
		) {
			self.isActive = isActive
			self.logUserDefaultsIdentifier = logUserDefaultsIdentifier
			self.logValue = logValue
			self.level = level
			self.userDefaultsIdentifierPrefix = userDefaultsIdentifierPrefix
			self.useOsLogger = useOsLogger
			self.loggerProvidable = loggerProvidable
		}
	}
}
