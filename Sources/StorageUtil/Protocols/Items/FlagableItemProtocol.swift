public protocol FlagableItemProtocol: ItemProtocol {
	func saveWithFlag (_ value: Value) -> Bool
	func saveIfFlag (_ value: Value) -> Bool
	func saveIfNotFlag (_ value: Value) -> Bool
}
