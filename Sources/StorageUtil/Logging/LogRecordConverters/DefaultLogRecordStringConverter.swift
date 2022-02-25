public struct DefaultLogRecordStringConverter: LogRecordStringConverter {
	public init () { }
	
	public func convert <Value> (_ record: LogRecord<Value>) -> String {
		var messageComponents = [String]()
				
		messageComponents.append(record.info.key.add(prefix: record.info.keyPrefix, postfix: record.details.keyPostfix).value)
		messageComponents.append(record.details.operation.uppercased())
		
		if let existance = record.details.existance {
			messageComponents.append(existance ? "Existed" : "Not existed")
		} else {
			messageComponents.append("Existance undefined")
		}
		
		if let oldValue = record.details.oldValue {
			messageComponents.append(String(describing: oldValue))
		} else {
			messageComponents.append("nil")
		}
		
		if let newValue = record.details.newValue {
			messageComponents.append(String(describing: newValue))
		} else {
			messageComponents.append("nil")
		}
		
		if let comment = record.details.comment {
			messageComponents.append(comment)
		}
		
		if let error = record.details.error {
			messageComponents.append("ERROR: \(error)")
		}
		
		let messsage = messageComponents.joined(separator: " | ")
		return messsage
	}
}
