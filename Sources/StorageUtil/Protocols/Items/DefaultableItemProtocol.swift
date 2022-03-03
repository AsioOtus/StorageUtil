public protocol DefaultableItemProtocol: KeyedItem {
	func loadOrDefault () -> Value
	func saveDefault () -> Bool
    func saveDefaultIfExists () -> Bool
	func saveDefaultIfNotExists () -> Bool
}
