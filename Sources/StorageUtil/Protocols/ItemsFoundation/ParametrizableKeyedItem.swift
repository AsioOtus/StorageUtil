import Foundation

public protocol ParametrizableKeyedItem: BaseItem {
	associatedtype KeyPostfixProviderType: KeyPostfixProvider
	
	var key: Key { get }
	
	func save (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool
	func saveIfNotExist (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool
	func load (_ keyPostfixProvider: KeyPostfixProviderType) -> Value?
	func delete (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool
	func isExists (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool
}
