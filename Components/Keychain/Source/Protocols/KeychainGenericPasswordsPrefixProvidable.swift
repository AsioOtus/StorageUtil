public protocol KeychainGenericPasswordsPrefixProvidable {
	var keychainGenericPasswordsPrefix: String { get }
}



extension String: KeychainGenericPasswordsPrefixProvidable {
	public var keychainGenericPasswordsPrefix: String { self }
}
