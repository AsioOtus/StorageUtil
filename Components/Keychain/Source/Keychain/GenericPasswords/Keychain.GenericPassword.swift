import Foundation

extension Keychain {
	open class GenericPassword <ItemType: Codable> {
		private lazy var logger = Logger("\(Keychain.self).\(String(describing: Self.self))")
		
		private static var commonAtributes: [CFString: Any] {
			[kSecClass: kSecClassGenericPassword]
		}
		
		private let savingQuery: [CFString: Any]
		private let loadingQuery: [CFString: Any]
		private let accessability: CFString
		
		private var fullSavingQuery: [CFString: Any] {
			let savingQuery = self.savingQuery.merging([kSecAttrAccessible: accessability]){ (current, _) in current }
			let fullSavingQuery = savingQuery.merging(Self.commonAtributes){ (current, _) in current }
			return fullSavingQuery
		}
		
		private var fullLoadingQuery: [CFString: Any] {
			let fullLoadingQuery = loadingQuery.merging(Self.commonAtributes){ (current, _) in current }
			return fullLoadingQuery
		}
		
		
		
		internal final var identifierPrefix: String { "\(Keychain.Settings.GenericPasswords.appIdentifier!).\(Keychain.self).\(String(describing: Self.self))" }
		public final let shortIdentifier: String
		public final var identifier: String { "\(identifierPrefix).\(shortIdentifier)" }
		
		private func appendIdentifierPostfix (_ postfixProvider: KeychainPostfixProvidable?) -> String {
			guard let postfixProvider = postfixProvider, !postfixProvider.postfix.isEmpty else { return identifier }
			return "\(self.identifier).\(postfixProvider.postfix)"
		}
		
		
		
		public init (_ shortIdentifier: String, savingQuery: [CFString: Any]? = nil, loadingQuery: [CFString: Any]? = nil, accessability: CFString = kSecAttrAccessibleWhenUnlockedThisDeviceOnly) {
			self.shortIdentifier = shortIdentifier
			self.savingQuery = savingQuery ?? [:]
			self.loadingQuery = loadingQuery ?? [:]
			self.accessability = accessability
		}
	}
}



public extension Keychain.GenericPassword {
	final func save (_ object: ItemType, _ identifierPostfixProvider: KeychainPostfixProvidable? = nil) throws {
		let identifier = appendIdentifierPostfix(identifierPostfixProvider)
		let savingQuery = self.fullSavingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.saving, identifier, savingQuery)
		
		let deletingQuery = Self.commonAtributes.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		do {
			let data = try Self.encode(object)
			try Keychain.delete(deletingQuery)
			try Keychain.save(savingQuery, data)
			
			logger.log(logRecord, .saving)
		} catch let error as Error.Category.Coding {
			logger.log(logRecord, .codingError(error))
			throw Error(identifier, .codingError(error))
		} catch let error as Keychain.Error {
			logger.log(logRecord, .keychainError(error))
			throw Error(identifier, .keychainError(error))
		} catch {
			logger.log(logRecord, .error(error))
			throw Error(identifier, .error(error))
		}
	}
	
	final func load (_ identifierPostfixProvider: KeychainPostfixProvidable? = nil) throws -> ItemType {
		let identifier = appendIdentifierPostfix(identifierPostfixProvider)
		let loadingQuery = self.fullLoadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }

		let logRecord = Logger.Record(.loading, identifier, loadingQuery)

		do {
			let anyObject = try Keychain.load(loadingQuery)
			guard let data = anyObject as? Data else { throw Error.Category.Coding.itemIsNotData }
			let object = try Self.decode(data, ItemType.self)
			
			logger.log(logRecord, .loading)
			return object
		} catch let error as Error.Category.Coding {
			logger.log(logRecord, .codingError(error))
			throw Error(identifier, .codingError(error))
		} catch let error as Keychain.Error {
			logger.log(logRecord, .keychainError(error))
			throw Error(identifier, .keychainError(error))
		} catch {
			logger.log(logRecord, .error(error))
			throw Error(identifier, .error(error))
		}
	}
	
	final func delete (_ identifierPostfixProvider: KeychainPostfixProvidable? = nil) throws {
		let identifier = appendIdentifierPostfix(identifierPostfixProvider)
		let deletingQuery = Self.commonAtributes.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.deletion, identifier, deletingQuery)
		
		do {
			try Keychain.delete(deletingQuery)
			logger.log(logRecord, .deletion(true))
		} catch Keychain.Error.itemNotFound {
			logger.log(logRecord, .deletion(false))
		} catch let error as Keychain.Error {
			logger.log(logRecord, .keychainError(error))
			throw Error(identifier, .keychainError(error))
		} catch {
			logger.log(logRecord, .error(error))
			throw Error(identifier, .error(error))
		}
	}
	
	final func isExists (_ identifierPostfixProvider: KeychainPostfixProvidable? = nil) throws -> Bool {
		let identifier = appendIdentifierPostfix(identifierPostfixProvider)
		let loadingQuery = self.fullLoadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.existance, identifier, loadingQuery)
		
		do {
			guard try Keychain.isExists(loadingQuery) else { return false }
			
			let anyObject = try Keychain.load(loadingQuery)
			guard let data = anyObject as? Data else { throw Error.Category.Coding.itemIsNotData }
			_ = try Self.decode(data, ItemType.self)
			
			logger.log(logRecord, .existance(true))
			return true
		} catch let error as Error.Category.Coding {
			logger.log(logRecord, .codingError(error))
			throw Error(identifier, .codingError(error))
		} catch let error as Keychain.Error {
			logger.log(logRecord, .keychainError(error))
			throw Error(identifier, .keychainError(error))
		} catch {
			logger.log(logRecord, .error(error))
			throw Error(identifier, .error(error))
		}
	}
}



private extension Keychain.GenericPassword {
	static func encode <T: Encodable> (_ object: T) throws -> Data {
		do {
			let data = try JSONEncoder().encode(object)
			return data
		} catch {
			throw Error.Category.Coding.encodingFailed(error)
		}
	}
	
	static func decode <T: Decodable> (_ data: Data, _ type: T.Type) throws -> T {
		do {
			let data = try JSONDecoder().decode(type, from: data)
			return data
		} catch {
			throw Error.Category.Coding.decodingFailed(error)
		}
	}
}
