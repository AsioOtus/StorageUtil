public protocol KeychainPostfixProvidable {
	var postfix: String { get }
}



extension String: KeychainPostfixProvidable {
	public var postfix: String { self }
}
