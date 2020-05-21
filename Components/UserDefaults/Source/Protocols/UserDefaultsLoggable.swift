import Foundation

public protocol UserDefaultsLoggable {
	var userDefaultsLog: String { get }
}



extension Data: UserDefaultsLoggable {
	public var userDefaultsLog: String { self.base64EncodedString() }
}
