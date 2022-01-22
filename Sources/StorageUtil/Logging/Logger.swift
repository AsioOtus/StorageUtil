public struct Logger<Value: Codable> {
	public let info: LogRecord<Value>.Info
	public let logHandler: LogHandler?
	
	public init (info: LogRecord<Value>.Info, logHandler: LogHandler?) {
		self.info = info
		self.logHandler = logHandler
	}
	
	public func log (_ details: LogRecord<Value>.Details) {
		logHandler?.log(.init(info: info, details: details))
	}
}
