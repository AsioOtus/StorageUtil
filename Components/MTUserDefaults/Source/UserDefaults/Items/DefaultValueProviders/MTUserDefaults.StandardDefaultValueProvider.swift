public extension MTUserDefaults {
	struct StandardDefaultValueProvider<DefaultValueType>: MTUserDefaultsDefaultValueProvider {
		public let defaultValue: DefaultValueType
		
		public init (_ defaultValue: DefaultValueType) {
			self.defaultValue = defaultValue
		}
	}
}
