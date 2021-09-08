public struct SingleLineLogRecordStringConverter: LogRecordStringConverter {
	public init () { }
	
	public func convert <Value> (_ record: LogRecord<Value>) -> String {
		var messageComponents = [String]()
		
		if let itemInfo = record.info.itemInfo {
			messageComponents.append("\(itemInfo.source.joined(separator: ".")) – \(itemInfo.uuid.uuidString)")
		} else {
			messageComponents.append("[Storage log]")
		}
		
		messageComponents.append(KeyBuilder.build(prefix: record.info.storageKeyPrefix, key: record.info.key, postfix: record.details.keyPostfix))
		messageComponents.append(record.details.operation.uppercased())
		
		if let existance = record.details.existance {
			messageComponents.append(existance.description)
		} else {
			messageComponents.append("Not exist")
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
