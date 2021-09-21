import Foundation

extension LogRecord {
	public struct Info {
		public struct ItemInfo {
			public let source: [String]
			public let label: String
			public let uuid: UUID
			public let file: String
			public let line: Int
			
		}
		
		public let key: String
		public let itemInfo: ItemInfo?
		public let storageLabel: String
		public let storageKeyPrefix: String?
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
