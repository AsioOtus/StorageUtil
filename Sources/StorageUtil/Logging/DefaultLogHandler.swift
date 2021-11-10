public struct DefaultLogHandler: LogHandler {
	public func log <Value> (_ logRecord: LogRecord<Value>) where Value : Decodable, Value : Encodable {
		print(logRecord.converted())
	}
}
