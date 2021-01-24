struct LocalizationObject {
	let key: String
	let params: [String]
	
	init (_ key: String, _ params: [String] = []) {
		self.key = key
		self.params = params
	}
}

extension LocalizationObject: ExpressibleByStringLiteral {
	init (stringLiteral key: String) {
		self.key = key
		self.params = []
	}
}

extension LocalizationObject {
	init (_ localizable: Localizable, _ params: [String] = []) {
		self.key = localizable.localizationKey
		self.params = params
	}
}

//extension LocalizationObject: LocalizableObject { }
