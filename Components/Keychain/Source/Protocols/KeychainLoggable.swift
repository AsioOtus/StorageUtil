import Foundation

public protocol KeychainLoggable {
	var keychainLog: String { get }
}



extension Data: KeychainLoggable {
	public var keychainLog: String { self.base64EncodedString() }
}
