public protocol UserDefaultsLoggingProvider {
	func log <T> (_: UserDefaults.Item<T>.Logger.Record.Commit.Info)
}
