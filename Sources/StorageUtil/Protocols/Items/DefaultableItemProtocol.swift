public protocol DefaultableItemProtocol: ItemProtocol {
	func loadOrDefault () -> Value
	func saveDefault () -> Bool
	func saveDefaultIfNotExist () -> Bool
}
