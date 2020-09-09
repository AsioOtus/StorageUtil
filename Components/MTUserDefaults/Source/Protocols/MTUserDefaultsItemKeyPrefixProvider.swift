public protocol MTUserDefaultsItemKeyPrefixProvider {
	var userDefaultsItemPrefix: String { get }
}



extension String: MTUserDefaultsItemKeyPrefixProvider {
	public var userDefaultsItemPrefix: String { self }
}
