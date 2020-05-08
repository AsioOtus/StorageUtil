extension Keychain {
	open class ParametricGenericPassword<ItemType: Codable, PostfixProviderType: KeychainGenericPasswordsPostfixProvidable>: GenericPassword<ItemType> {
		public final func save (_ object: ItemType, _ postfixProvider: PostfixProviderType) throws {
			try super.save(object, postfixProvider)
		}
		
		public final  func load (_ postfixProvider: PostfixProviderType) throws -> ItemType {
			let object = try super.load(postfixProvider)
			return object
		}
		
		public final  func delete (_ postfixProvider: PostfixProviderType) throws {
			try super.delete(postfixProvider)
		}
		
		public final  func isExists (_ postfixProvider: PostfixProviderType) throws -> Bool {
			let isExists = try super.isExists(postfixProvider)
			return isExists
		}
	}
}
