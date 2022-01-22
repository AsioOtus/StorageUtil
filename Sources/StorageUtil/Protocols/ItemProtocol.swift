import Foundation

public protocol ItemProtocol {
	associatedtype Value: Codable
	
	var key: String { get }
	var storage: Storage { get }
	
	var accessQueue: DispatchQueue { get }
	var logger: Logger<Value> { get }
	
	func save (_ value: Value) -> Bool
	func saveIfNotExists (_ value: Value) -> Bool
	func load () -> Value?
	func delete () -> Bool
	func isExists () -> Bool
}
