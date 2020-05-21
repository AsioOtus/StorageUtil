public protocol UserDefaultsItemPostfixProvidable {
	var userDefaultsItemPostfix: String { get }
}



extension String: UserDefaultsItemPostfixProvidable {
	public var userDefaultsItemPostfix: String { self }
}
