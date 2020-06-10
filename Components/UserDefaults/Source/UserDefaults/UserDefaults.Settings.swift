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
		public var logging: Logging
		
		public let itemKeyPrefixProvider: UserDefaultsItemKeyPrefixProvider?
		
		public init (
			itemKeyPrefixProvider: UserDefaultsItemKeyPrefixProvider,
			logging: Logging = .default
		) {
			self.itemKeyPrefixProvider = itemKeyPrefixProvider
			self.logging = logging
		}
		
		internal static let `default` = Items()
		private init () {
			self.itemKeyPrefixProvider = nil
			self.logging = .default
		}
	}
}



extension UserDefaults.Settings.Items {
	public struct Logging {
		public var enable: Bool
		public var level: OSLogType
		
		public var enableUserDefaultsIdentifierLogging: Bool
		public var enableValuesLogging: Bool
				
		public var loggingProvider: UserDefaultsLoggingProvider?
		
		public static let `default` = Logging()
		public init (
			enable: Bool = true,
			level: OSLogType = .default,
			
			enableUserDefaultsIdentifierLogging: Bool = true,
			enableValuesLogging: Bool = false,
			
			loggingProvider: UserDefaultsLoggingProvider? = nil
		) {
			self.enable = enable
			self.level = level
			
			self.enableUserDefaultsIdentifierLogging = enableUserDefaultsIdentifierLogging
			self.enableValuesLogging = enableValuesLogging
			
			self.loggingProvider = loggingProvider
		}
	}
}
