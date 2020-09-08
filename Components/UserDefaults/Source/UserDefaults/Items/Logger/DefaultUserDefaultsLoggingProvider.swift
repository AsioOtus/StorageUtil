import os.log

public struct DefaultUserDefaultsLoggingProvider: UserDefaultsLoggingProvider {
	public var prefix: String?
	
	public init (prefix: String? = nil) {
		self.prefix = prefix
	}
	
	public func log <T: Codable> (_ info: UserDefaults.Item<T>.Logger.Record.Info) {
		let log = OSLog(subsystem: info.userDefaultsItemIdentifier, category: "UserDefaults")
		
		let prefix = self.prefix ?? ""
		let preparedPrefix = !info.userDefaultsItemIdentifier.isEmpty && !prefix.isEmpty
			? "\(prefix).\(info.userDefaultsItemIdentifier)"
			: ""
		
		let message = "\(preparedPrefix) – \(info.defaultMessage)"
		
		os_log("%{public}@", log: log, type: info.level, message)
	}
}
