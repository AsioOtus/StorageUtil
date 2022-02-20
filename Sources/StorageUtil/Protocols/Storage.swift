public protocol Storage {
	var keyPrefix: String? { get }
	var logHandler: LogHandler? { get }
	var identificationInfo: IdentificationInfo { get }
	
	func save <Value: Codable> (_ key: Key, _ value: Value) throws -> Value?
	func load <Value: Codable> (_ key: Key, _ type: Value.Type) throws -> Value?
	func delete <Value: Codable> (_ key: Key, _ type: Value.Type) throws -> Value?
}
