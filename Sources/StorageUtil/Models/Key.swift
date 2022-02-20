public struct Key {
	let value: String
	
	func add (prefix: String? = nil, postfix: String? = nil) -> Key {
		.init(value: [prefix, value, postfix].compactMap{ $0 }.joined(separator: "."))
	}
}

extension Key: ExpressibleByStringLiteral {
	public init (stringLiteral key: String) {
		self.value = key
	}
}
