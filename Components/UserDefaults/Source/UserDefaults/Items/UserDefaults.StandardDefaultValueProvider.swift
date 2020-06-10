public extension UserDefaults {
	struct StandardDefaultValueProvider<DefaultValueType>: UserDefaultsDefaultValueProvider {
		public let defaultValue: DefaultValueType
		
		public init (_ defaultValue: DefaultValueType) {
			self.defaultValue = defaultValue
		}
	}
}
