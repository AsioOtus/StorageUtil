public protocol KeychainGenericPasswordsPostfixProvidable {
	var keychainGenericPasswordsPostfix: String { get }
}



extension String: KeychainGenericPasswordsPostfixProvidable {
	public var keychainGenericPasswordsPostfix: String { self }
}
