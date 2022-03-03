import Foundation

public protocol BaseItem {
	associatedtype Value: Codable
	
	var accessQueue: DispatchQueue { get }
	var logger: Logger<Value> { get }
	
	var storage: Storage { get }
	
	func save (_ key: Key, _ value: Value) throws -> Value?
	func load (_ key: Key) throws -> Value?
	func delete (_ key: Key) throws -> Value?
}
