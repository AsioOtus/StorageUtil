public protocol MTUserDefaultsDefaultValueProvider {
	associatedtype DefaultValueType
	
	var defaultValue: DefaultValueType { get }
}
