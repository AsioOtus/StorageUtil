public protocol MTUserDefaultsItemKeyPostfixProvider {
	var userDefaultsItemPostfix: String { get }
}



extension String: MTUserDefaultsItemKeyPostfixProvider {
	public var userDefaultsItemPostfix: String { self }
}
