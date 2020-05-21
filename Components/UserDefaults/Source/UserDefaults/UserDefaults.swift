import Foundation

public extension UserDefaults {
	func save <T: Encodable> (_ object: T, _ key: String) throws {
		let data = try Self.encode(object)
		set(data, forKey: key)
	}
	
	func load <T: Decodable> (_ key: String, _ type: T.Type) throws -> T? {
		guard let data = data(forKey: key) else { return nil }
		let object = try Self.decode(data, type)
		
		return object
	}
	
	func delete (_ key: String) {
		removeObject(forKey: key)
	}
	
	func isExists <T: Decodable> (_ key: String, _ type: T.Type) throws -> Bool {
		guard let data = data(forKey: key) else { return false }
		_ = try Self.decode(data, type)
		
		return true
	}
}



private extension UserDefaults {
	static func encode <T: Encodable> (_ object: T) throws -> Data {
		do {
			let data = try JSONEncoder().encode(object)
			return data
		} catch {
			throw Error.encodingFailed(error)
		}
	}
	
	static func decode <T: Decodable> (_ data: Data, _ type: T.Type) throws -> T {
		do {
			let data = try JSONDecoder().decode(type, from: data)
			return data
		} catch {
			throw Error.decodingFailed(error)
		}
	}
}
