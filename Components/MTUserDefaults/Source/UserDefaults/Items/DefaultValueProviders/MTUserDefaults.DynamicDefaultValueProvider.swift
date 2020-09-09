public extension MTUserDefaults {
	struct DynamicDefaultValueProvider <DefaultValueType>: MTUserDefaultsDefaultValueProvider {
		private let defaultValueSource: () -> DefaultValueType
		
		public var defaultValue: DefaultValueType {
			defaultValueSource()
		}
		
		public init (_ defaultValueSource: @escaping () -> DefaultValueType) {
			self.defaultValueSource = defaultValueSource
		}
	}
}
