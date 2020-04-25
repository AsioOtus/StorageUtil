import Foundation



public struct Keychain { }



public extension Keychain {
	static func save <T: Encodable> (_ query: [CFString: Any], _ object: T) throws {
		let logRecord = Logger.Record(.saving, query)
		
		do {
			let data = try encode(object)
			let query = query.merging([kSecValueData: data]){ (current, _) in current }
			
			let status = SecItemAdd(query as CFDictionary, nil)

			guard status != errSecDuplicateItem else { throw Error.existingItemFound }
			guard status == errSecSuccess else { throw Error.savingFailed(status) }
			
			logRecord.log(.saving)
		} catch {
			logRecord.log(.error(error))
			throw error
		}
	}
	
	static func load <T: Decodable> (_ query: [CFString: Any], _ type: T.Type) throws -> T {
		let logRecord = Logger.Record(.loading, query)
		
		do {
			let loadingAttributes: [CFString: Any] = [
				kSecReturnData: kCFBooleanTrue as Any,
				kSecMatchLimit: kSecMatchLimitOne
			]
			let query = query.merging(loadingAttributes){ (current, _) in current }

			var item: CFTypeRef?
			let status = SecItemCopyMatching(query as CFDictionary, &item)

			guard status != errSecItemNotFound else { throw Error.itemNotFound }
			guard status == errSecSuccess else { throw Error.loadingFailed(status) }
			guard let data = item as? Data else { throw Error.itemIsNotData }
			
			let object = try decode(data, type)
			logRecord.log(.loading)
			return object
		} catch {
			logRecord.log(.error(error))
			throw error
		}
	}
	
	static func delete (_ query: [CFString: Any]) throws {
		let logRecord = Logger.Record(.deletion, query)
		
		do {
			let status = SecItemDelete(query as CFDictionary)
			guard status == errSecSuccess || status == errSecItemNotFound else { throw Error.deletingFailed(status) }
			logRecord.log(.deletion)
		} catch {
			logRecord.log(.error(error))
			throw error
		}
	}
	
	static func isExists <T: Decodable> (_ query: [CFString: Any], _ type: T.Type) throws -> Bool {
		let logRecord = Logger.Record(.existance, query)
		let isExists: Bool
		
		do {
			let loadingAttributes: [CFString: Any] = [
				kSecReturnData: kCFBooleanTrue as Any,
				kSecMatchLimit: kSecMatchLimitOne
			]
			let query = query.merging(loadingAttributes){ (current, _) in current }
			
			var item: CFTypeRef?
			let status = SecItemCopyMatching(query as CFDictionary, &item)
			
			guard status != errSecItemNotFound else { throw Error.itemNotFound }
			guard status == errSecSuccess else { throw Error.existanceCheckFailed(status) }
			guard let data = item as? Data else { throw Error.itemIsNotData }
			
			_ = try decode(data, type)
			
			isExists = true
			logRecord.log(.existance(isExists))
			return isExists
		} catch Error.itemNotFound {
			isExists = false
			logRecord.log(.existance(isExists))
			return isExists
		} catch {
			logRecord.log(.error(error))
			throw error
		}
	}
}



public extension Keychain {
	@discardableResult
	static func clear () -> [Keychain.Class: OSStatus] {
		let logRecord = Logger.Record(.clearing, [:])
		
		var deleteResults = [Keychain.Class: OSStatus]()
		
		for keychainClass in Keychain.Class.allCases {
			let logRecord = Logger.Record(.clearingClass, [:])
			
			let query = [kSecClass: keychainClass.keychainIdentifier]
			let status = SecItemDelete(query as CFDictionary)
			
			logRecord.log(.clearingClass(keychainClass, status))
			
			deleteResults[keychainClass] = status
		}
		
		logRecord.log(.clearing(deleteResults))
		
		return deleteResults
	}
	
	@discardableResult
	static func clear (_ keychainClass: Keychain.Class) -> OSStatus {
		let logRecord = Logger.Record(.clearingClass, [:])
		
		let query = [kSecClass: keychainClass.keychainIdentifier]
		let status = SecItemDelete(query as CFDictionary)
		
		logRecord.log(.clearingClass(keychainClass, status))
		
		return status
	}
}



private extension Keychain {
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
