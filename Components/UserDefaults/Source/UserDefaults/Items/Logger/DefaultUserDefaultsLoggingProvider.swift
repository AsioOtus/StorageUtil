import os.log

public struct DefaultUserDefaultsLoggingProvider: UserDefaultsLoggingProvider {
	public static let defaultInstance = Self(prefix: nil)
	
	public var prefix: String?
	
	public init (prefix: String?) {
		self.prefix = prefix
	}
	
	public func log <T: Codable> (_ info: UserDefaults.Item<T>.Logger.Record.Commit.Info) {
		let log = OSLog(subsystem: "UserDefaults.Item<\(String(describing: T.self))>", category: "UserDefaults")
		
		let prefix = self.prefix ?? ""
		let preparedPrefix = !info.defaultMessage.isEmpty && !prefix.isEmpty ? prefix + "." : ""
		
		os_log("%{public}@%{public}@", log: log, type: info.level, preparedPrefix, info.defaultMessage)
	}
}
