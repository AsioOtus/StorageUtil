public protocol MTUserDefaultsLoggingProvider {
	func log <T> (_: MTUserDefaults.Item<T>.Logger.Record.Info)
}
