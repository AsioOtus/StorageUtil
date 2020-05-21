import Foundation

extension Keychain {
	open class GenericPassword <ItemType: Codable> {
		private lazy var logger = Logger(String(describing: Self.self), enableValueLogging)
		
		private static var commonAtributes: [CFString: Any] {
			[kSecClass: kSecClassGenericPassword]
		}
		
		private let baseSavingQuery: [CFString: Any]
		private let baseLoadingQuery: [CFString: Any]
		private let accessability: CFString
		private let enableValueLogging: Bool
		
		public var savingQuery: [CFString: Any] {
			let savingQuery = self.baseSavingQuery.merging([kSecAttrAccessible: accessability]){ (current, _) in current }
			let fullSavingQuery = savingQuery.merging(Self.commonAtributes){ (current, _) in current }
			return fullSavingQuery
		}
		
		public var loadingQuery: [CFString: Any] {
			let fullLoadingQuery = baseLoadingQuery.merging(Self.commonAtributes){ (current, _) in current }
			return fullLoadingQuery
		}
		
		
		
		internal final var identifierPrefix: String {
			guard let prefixProvider = Keychain.Settings.current.genericPasswords.prefixProvider else { fatalError("Keychain.Settings.current.genericPasswords.prefixProvider is nil") }
			let prefix = prefixProvider.keychainGenericPasswordsPrefix
			return prefix
		}
		public final let itemIdentifier: String
		public final var identifier: String { "\(identifierPrefix).\(itemIdentifier)" }
		public final func postfixedIdentifier (_ postfixProvider: KeychainGenericPasswordsPostfixProvidable?) -> String {
			guard let postfixProvider = postfixProvider else { return identifier }
			
			let postfix = postfixProvider.keychainGenericPasswordsPostfix.trimmingCharacters(in: .whitespacesAndNewlines)
			
			guard !postfix.isEmpty else { return identifier }
			
			return "\(self.identifier).\(postfix)"
		}
		
		
		
		public init (_ shortIdentifier: String, savingQuery: [CFString: Any]? = nil, loadingQuery: [CFString: Any]? = nil, accessability: CFString = kSecAttrAccessibleWhenUnlockedThisDeviceOnly, enableValueLogging: Bool = false) {
			self.itemIdentifier = shortIdentifier
			self.baseSavingQuery = savingQuery ?? [:]
			self.baseLoadingQuery = loadingQuery ?? [:]
			self.accessability = accessability
			
			self.enableValueLogging = enableValueLogging
		}
	}
}



public extension Keychain.GenericPassword {
	final func save (_ object: ItemType, _ identifierPostfixProvider: KeychainGenericPasswordsPostfixProvidable? = nil) throws {
		let identifier = postfixedIdentifier(identifierPostfixProvider)
		let savingQuery = self.savingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.saving(object), identifier, savingQuery)
		
		do {
			let deletingQuery = Self.commonAtributes.merging([kSecAttrService: identifier]){ (current, _) in current }
			try Keychain.delete(deletingQuery)
		}
		catch Keychain.Error.itemNotFound { }
		catch {
			
			logger.log(logRecord.commit(.genericError(error)))
			throw Error(identifier, .error(error))
			
		}
		
		do {
			let data = try Self.encode(object)
			try Keychain.save(savingQuery, data)
			
			logger.log(logRecord.commit(.saving))
			
		} catch let error as Error.Category.Coding {
			
			logger.log(logRecord.commit(.codingError(error)))
			throw Error(identifier, .codingError(error))
			
		} catch let error as Keychain.Error {
			
			logger.log(logRecord.commit(.keychainError(error)))
			throw Error(identifier, .keychainError(error))
			
		} catch {
			
			logger.log(logRecord.commit(.genericError(error)))
			throw Error(identifier, .error(error))
			
		}
	}
	
	final func load (_ identifierPostfixProvider: KeychainGenericPasswordsPostfixProvidable? = nil) throws -> ItemType {
		let identifier = postfixedIdentifier(identifierPostfixProvider)
		let loadingQuery = self.loadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }

		let logRecord = Logger.Record(.loading, identifier, loadingQuery)

		do {
			let anyObject = try Keychain.load(loadingQuery)
			guard let data = anyObject as? Data else { throw Error.Category.Coding.itemIsNotData }
			let object = try Self.decode(data, ItemType.self)
			
			logger.log(logRecord.commit(.loading(object)))
			
			return object
			
		} catch let error as Error.Category.Coding {
			
			logger.log(logRecord.commit(.codingError(error)))
			throw Error(identifier, .codingError(error))
			
		} catch let error as Keychain.Error {
			
			logger.log(logRecord.commit(.keychainError(error)))
			throw Error(identifier, .keychainError(error))
			
		} catch {
			
			logger.log(logRecord.commit(.genericError(error)))
			throw Error(identifier, .error(error))
			
		}
	}
	
	final func delete (_ identifierPostfixProvider: KeychainGenericPasswordsPostfixProvidable? = nil) throws {
		let identifier = postfixedIdentifier(identifierPostfixProvider)
		let deletingQuery = Self.commonAtributes.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.deletion, identifier, deletingQuery)
		
		do {
			try Keychain.delete(deletingQuery)
			
			logger.log(logRecord.commit(.deletion(true)))
			
		} catch Keychain.Error.itemNotFound {
			
			logger.log(logRecord.commit(.deletion(false)))
			
		} catch let error as Keychain.Error {
			
			logger.log(logRecord.commit(.keychainError(error)))
			throw Error(identifier, .keychainError(error))
			
		} catch {
			
			logger.log(logRecord.commit(.genericError(error)))
			throw Error(identifier, .error(error))
			
		}
	}
	
	final func isExists (_ identifierPostfixProvider: KeychainGenericPasswordsPostfixProvidable? = nil) throws -> Bool {
		let identifier = postfixedIdentifier(identifierPostfixProvider)
		let loadingQuery = self.loadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.existance, identifier, loadingQuery)
		
		do {
			guard try Keychain.isExists(loadingQuery) else {
				logger.log(logRecord.commit(.existance(false)))
				return false
			}
			
			let anyObject = try Keychain.load(loadingQuery)
			guard let data = anyObject as? Data else { throw Error.Category.Coding.itemIsNotData }
			let object = try Self.decode(data, ItemType.self)
			
			logger.log(logRecord.commit(.existance(true, object)))
			return true
			
		} catch let error as Error.Category.Coding {
			
			logger.log(logRecord.commit(.codingError(error)))
			throw Error(identifier, .codingError(error))
			
		} catch let error as Keychain.Error {
			
			logger.log(logRecord.commit(.keychainError(error)))
			throw Error(identifier, .keychainError(error))
			
		} catch {
			
			logger.log(logRecord.commit(.genericError(error)))
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
			let object = try JSONDecoder().decode(type, from: data)
			return object
		} catch {
			throw Error.Category.Coding.decodingFailed(error)
		}
	}
}
