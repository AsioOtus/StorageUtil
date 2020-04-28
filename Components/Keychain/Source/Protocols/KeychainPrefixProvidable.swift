public protocol KeychainPrefixProvidable {
	var prefix: String { get }
	var additionalPrefix: String? { get }
}



extension String: KeychainPrefixProvidable {
	public var prefix: String { self }
	public var additionalPrefix: String? { nil }
}
