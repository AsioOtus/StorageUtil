public protocol FlagableItemProtocol: KeyedItem {
	func save (_ value: Value, flag: Bool) -> Bool
	func saveIfFlag (_ value: Value) -> Bool
	func saveIfNotFlag (_ value: Value) -> Bool
}
