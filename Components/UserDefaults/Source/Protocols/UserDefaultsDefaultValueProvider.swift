public protocol UserDefaultsDefaultValueProvider {
	associatedtype DefaultValueType
	
	var defaultValue: DefaultValueType { get }
}
