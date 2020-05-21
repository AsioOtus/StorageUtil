public protocol UserDefaultsItemPrefixProvidable {
	var userDefaultsItemPrefix: String { get }
}



extension String: UserDefaultsItemPrefixProvidable {
	public var userDefaultsItemPrefix: String { self }
}
