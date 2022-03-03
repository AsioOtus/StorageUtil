public struct Key {
	let value: String
	
    public init (_ value: String) {
        self.value = value
    }
    
	func add (prefix: String? = nil, postfix: String? = nil) -> Key {
		.init(value: [prefix, value, postfix].compactMap{ $0 }.joined(separator: "."))
	}
}

public extension Key {
	func item <Value> (
		type: Value.Type,
		storage: Storage = Global.parameters.defaultStorage,
		logHandler: LogHandler? = Global.parameters.defaultLogHandler,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Item<Value> {
		.init(
			key: self,
			storage: storage,
			logHandler: logHandler,
			label: label,
			file: file,
			line: line
		)
	}
}

extension Key: ExpressibleByStringLiteral {
	public init (stringLiteral value: String) {
		self.value = value
	}
}
