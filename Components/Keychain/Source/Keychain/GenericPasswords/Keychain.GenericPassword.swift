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
		
		let logRecord = Logger.Record<ItemType>(.saving, identifier, savingQuery, logger)
		
		let deletingQuery = Self.commonAtributes.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		do {
			try Keychain.delete(deletingQuery)
			try Keychain.save(savingQuery, object)
			
			logRecord.log(.saving)
		} catch let error as Keychain.Error {
			logRecord.log(.keychainError(error))
			throw Error(identifier, error)
		} catch {
			logRecord.log(.error(error))
			throw error
		}
	}
	
	final func load (_ identifierPostfixProvider: KeychainPostfixProvidable? = nil) throws -> ItemType {
		let identifier = appendIdentifierPostfix(identifierPostfixProvider)
		let loadingQuery = self.fullLoadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record<ItemType>(.loading, identifier, loadingQuery, logger)
		
		do {
			let object = try Keychain.load(loadingQuery, ItemType.self)
			logRecord.log(.loading)
			return object
		} catch let error as Keychain.Error {
			logRecord.log(.keychainError(error))
			throw Error(identifier, error)
		} catch {
			logRecord.log(.error(error))
			throw error
		}
	}
	
	final func delete (_ identifierPostfixProvider: KeychainPostfixProvidable? = nil) throws {
		let identifier = appendIdentifierPostfix(identifierPostfixProvider)
		let deletingQuery = Self.commonAtributes.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record<ItemType>(.deletion, identifier, deletingQuery, logger)
		
		do {
			try Keychain.delete(deletingQuery)
			logRecord.log(.deletion)
		} catch let error as Keychain.Error {
			logRecord.log(.keychainError(error))
			throw Error(identifier, error)
		} catch {
			logRecord.log(.error(error))
			throw error
		}
	}
	
	final func isExists (_ identifierPostfixProvider: KeychainPostfixProvidable? = nil) throws -> Bool {
		let identifier = appendIdentifierPostfix(identifierPostfixProvider)
		let loadingQuery = self.fullLoadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record<ItemType>(.existance, identifier, loadingQuery, logger)
		
		do {
			let isExists = try Keychain.isExists(loadingQuery, ItemType.self)
			logRecord.log(.existance(isExists))
			return isExists
		} catch let error as Keychain.Error {
			logRecord.log(.keychainError(error))
			throw Error(identifier, error)
		} catch {
			logRecord.log(.error(error))
			throw error
		}
	}
}
