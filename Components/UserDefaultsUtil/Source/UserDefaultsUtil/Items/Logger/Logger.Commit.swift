import os.log

extension Logger {
	struct Commit<ValueType> {
		let key: String
		
		var level: OSLogType
		var operation: String
		
		var newValue: ValueType?
		var oldValue: ValueType?
		var existance: Bool
		
		var additional: String?
		var error: Error?
	}
}
