public extension UserDefaults {
	struct DynamicDefaultValueProvider <DefaultValueType>: UserDefaultsDefaultValueProvider {
		private let defaultValueSource: () -> DefaultValueType
		
		public var defaultValue: DefaultValueType {
			defaultValueSource()
		}
		
		public init (_ defaultValueSource: @escaping () -> DefaultValueType) {
			self.defaultValueSource = defaultValueSource
		}
	}
}
