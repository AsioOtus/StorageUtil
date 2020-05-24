import os.log

public struct DefaultKeychainGenericPasswordsLoggingProvider: KeychainGenericPasswordsLoggingProvider {
	public static let defaultInstance = Self(prefix: nil)
	
	public var prefix: String?
	
	public init (prefix: String?) {
		self.prefix = prefix
	}
	
	public func log <T: Codable> (_ info: Keychain.GenericPassword<T>.Logger.Record.Info) {
		let log = OSLog(subsystem: "Keychain.GenericPassword<\(String(describing: T.self))>", category: "Keychain")
		
		let prefix = self.prefix ?? ""
		let preparedPrefix = !info.defaultMessage.isEmpty && !prefix.isEmpty ? prefix + "." : ""
		
		os_log("%{public}@%{public}@", log: log, type: info.level, preparedPrefix, info.defaultMessage)
	}
}
