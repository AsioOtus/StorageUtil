public protocol ItemProtocol: BaseItemProtocol {	
	var key: Key { get }
	
	func save (_ value: Value) -> Bool
	func saveIfExists (_ value: Value) -> Bool
	func saveIfNotExists (_ value: Value) -> Bool
	func load () -> Value?
	func delete () -> Bool
	func isExists () -> Bool
}
