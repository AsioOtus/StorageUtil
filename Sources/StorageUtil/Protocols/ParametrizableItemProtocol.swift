import Foundation

public protocol ParametrizableItemProtocol {
	associatedtype Value: Codable
	associatedtype KeyPostfixProviderType: KeyPostfixProvider
	
	var key: String { get }
	var storage: Storage { get }
	
	var accessQueue: DispatchQueue { get }
	var logger: Logger<Value> { get }
	
	func save (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool
	func saveIfNotExist (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool
	func load (_ keyPostfixProvider: KeyPostfixProviderType) -> Value?
	func delete (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool
	func isExists (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool
}
