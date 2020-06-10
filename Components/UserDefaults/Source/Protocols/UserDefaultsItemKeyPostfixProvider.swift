public protocol UserDefaultsItemKeyPostfixProvider {
	var userDefaultsItemPostfix: String { get }
}



extension String: UserDefaultsItemKeyPostfixProvider {
	public var userDefaultsItemPostfix: String { self }
}
