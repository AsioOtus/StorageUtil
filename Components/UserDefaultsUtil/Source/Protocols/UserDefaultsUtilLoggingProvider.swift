public protocol UserDefaultsUtilLoggingProvider {
	func userDefaultsUtilLog <ValueType> (_: UserDefaultsUtil.Logger.Info<ValueType>)
}
