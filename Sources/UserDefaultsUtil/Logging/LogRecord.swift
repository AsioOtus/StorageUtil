import Foundation

extension LogRecord {
	public struct Info {
		public let storageKeyPrefix: String?
		public let key: String
		public let storageIdentificationInfo: IdentificationInfo
		public let itemIdentificationInfo: IdentificationInfo?
	}
}

extension LogRecord {
	public struct Details {
		public let operation: String
		
		public var newValue: Value? = nil
		public var oldValue: Value? = nil
		public var existance: Bool? = nil
		public var keyPostfix: String? = nil
		
		public var error: UserDefaultsUtilError? = nil
		public var comment: String? = nil
	}
}

public struct LogRecord<Value: Codable> {
	public let info: Info
	public let details: Details
	
	public func converted (_ converter: LogRecordStringConverter = SingleLineLogRecordStringConverter()) -> String {
		converter.convert(self)
	}
}
