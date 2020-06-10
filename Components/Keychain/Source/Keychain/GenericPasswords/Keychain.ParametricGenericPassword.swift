extension Keychain {
	open class ParametricGenericPassword<ItemType: Codable, ItemIdentifierPostfixProviderType: KeychainGenericPasswordsItemIdentifierPostfixProvider>: GenericPassword<ItemType> {
		public func postfixedKey (_ identifierPostfixProvider: ItemIdentifierPostfixProviderType?) -> String {
			let postfixedKey = super.postfixedIdentifier(identifierPostfixProvider)
			return postfixedKey
		}
		
		public final func save (_ object: ItemType, _ postfixProvider: ItemIdentifierPostfixProviderType) throws {
			try super.save(object, postfixProvider)
		}
		
		public final  func load (_ postfixProvider: ItemIdentifierPostfixProviderType) throws -> ItemType {
			let object = try super.load(postfixProvider)
			return object
		}
		
		public final  func delete (_ postfixProvider: ItemIdentifierPostfixProviderType) throws {
			try super.delete(postfixProvider)
		}
		
		public final  func isExists (_ postfixProvider: ItemIdentifierPostfixProviderType) throws -> Bool {
			let isExists = try super.isExists(postfixProvider)
			return isExists
		}
	}
}
