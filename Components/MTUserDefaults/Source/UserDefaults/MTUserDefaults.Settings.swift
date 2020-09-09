import Foundation
import os



extension MTUserDefaults {
	public struct Settings {		
		public let items: Items
		
		public init (
			items: Items
		) {
			self.items = items
		}
		
		internal static let `default` = Settings()
		private init () {
			self.items = .default
		}
	}
}



extension MTUserDefaults.Settings {
	public struct Items {
		public var logging: Logging
		
		public let itemKeyPrefixProvider: MTUserDefaultsItemKeyPrefixProvider?
		
		public init (
			itemKeyPrefixProvider: MTUserDefaultsItemKeyPrefixProvider,
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



extension MTUserDefaults.Settings.Items {
	public struct Logging {
		public var enable: Bool
		public var level: OSLogType
		public var enableValuesLogging: Bool
				
		public var loggingProvider: MTUserDefaultsLoggingProvider?
		
		public static let `default` = Logging()
		public init (
			enable: Bool = true,
			level: OSLogType = .default,
			enableValuesLogging: Bool = false,
			
			loggingProvider: MTUserDefaultsLoggingProvider? = nil
		) {
			self.enable = enable
			self.level = level
			self.enableValuesLogging = enableValuesLogging
			
			self.loggingProvider = loggingProvider
		}
	}
}
