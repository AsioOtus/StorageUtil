public protocol UserDefaultsItemKeyPrefixProvider {
	var userDefaultsItemPrefix: String { get }
}



extension String: UserDefaultsItemKeyPrefixProvider {
	public var userDefaultsItemPrefix: String { self }
}
