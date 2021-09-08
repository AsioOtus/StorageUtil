import Foundation

extension LogRecord {
	public struct Info {
		public struct ItemInfo {
			let source: [String]
			let label: String
			let uuid: UUID
			let file: String
			let line: Int
			
		}
		
		let key: String
		let itemInfo: ItemInfo?
		let storageLabel: String
		let storageKeyPrefix: String?
	}
}

extension LogRecord {
	public struct Details {
		let operation: String
		
		var newValue: Value? = nil
		var oldValue: Value? = nil
		var existance: Bool? = nil
		var keyPostfix: String? = nil
		
		var error: Error? = nil
		var comment: String? = nil
	}
}

public struct LogRecord<Value: Codable> {
	let info: Info
	let details: Details
	
	public func converted (_ converter: LogRecordStringConverter = SingleLineLogRecordStringConverter()) -> String {
		converter.convert(self)
	}
}
