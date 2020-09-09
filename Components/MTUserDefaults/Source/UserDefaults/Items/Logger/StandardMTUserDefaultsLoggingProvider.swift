import os.log

extension MTUserDefaults {
	public struct StandardLoggingProvider: MTUserDefaultsLoggingProvider {
		public var prefix: String?
		
		public init (prefix: String? = nil) {
			self.prefix = prefix
		}
		
		public func log <T: Codable> (_ info: MTUserDefaults.Item<T>.Logger.Record.Info) {
			let log = OSLog(subsystem: info.userDefaultsItemIdentifier, category: "MTUserDefaults")
			
			let prefix = self.prefix ?? ""
			let preparedPrefix = !info.userDefaultsItemIdentifier.isEmpty && !prefix.isEmpty
				? "\(prefix)."
				: ""
			
			let message = "\(preparedPrefix)\(info.userDefaultsItemIdentifier) – \(info.defaultMessage)"
			
			os_log("%{public}@", log: log, type: info.level, message)
		}
	}
}
