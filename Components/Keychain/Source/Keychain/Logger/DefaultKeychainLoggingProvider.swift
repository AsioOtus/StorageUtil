import os.log

public struct DefaultKeychainLoggingProvider: KeychainLoggingProvider {
	public static let defaultInstance = Self(prefix: nil)
	
	public var prefix: String?
	
	public init (prefix: String?) {
		self.prefix = prefix
	}
	
	public func log (_ info: Keychain.Logger.Record.Commit.Info) {
		let log = OSLog(subsystem: "Keychain", category: "Keychain")
		
		let prefix = self.prefix ?? ""
		let preparedPrefix = !info.defaultMessage.isEmpty && !prefix.isEmpty ? prefix + "." : ""
		
		os_log("%{public}@%{public}@", log: log, type: info.level, preparedPrefix, info.defaultMessage)
	}
}
