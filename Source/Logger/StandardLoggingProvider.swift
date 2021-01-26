import os.log

public struct StandardLoggingProvider: UserDefaultsUtilLoggingProvider {
	public var prefix: String?
	
	public init (prefix: String? = nil) {
		self.prefix = prefix
	}
	
	public func userDefaultsUtilLog <ValueType> (_ info: Logger.Info<ValueType>) {
		let log = OSLog(subsystem: info.userDefaultsItemTypeName, category: "UserDefaultsUtil")
		
		let prefix = self.prefix ?? ""
		let preparedPrefix = !info.userDefaultsItemTypeName.isEmpty && !prefix.isEmpty
			? "\(prefix)."
			: ""
		
		let message = "\(preparedPrefix)\(info.userDefaultsItemTypeName) – \(info.defaultMessage)"
		
		os_log("%{public}@", log: log, type: info.level, message)
	}
}
