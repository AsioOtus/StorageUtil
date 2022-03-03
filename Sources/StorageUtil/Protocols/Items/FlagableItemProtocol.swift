public protocol FlagableItemProtocol: KeyedItem {
	func saveWithFlag (_ value: Value) -> Bool
	func saveIfFlag (_ value: Value) -> Bool
	func saveIfNotFlag (_ value: Value) -> Bool
}
