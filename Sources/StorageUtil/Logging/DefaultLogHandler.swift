public struct DefaultLogHandler: LogHandler {
	public init () { }
	
	public func log <Value> (_ logRecord: LogRecord<Value>) where Value : Decodable, Value : Encodable {
		print(logRecord.converted())
	}
	
	public func log <Value> (_ logRecord: LogRecord<Value?>) where Value : Decodable, Value : Encodable {
		print(logRecord.converted())
	}
}
