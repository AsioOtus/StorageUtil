public protocol KeychainGenericPasswordsLoggingProvider {
	func log <T> (_: Keychain.GenericPassword<T>.Logger.Record.Commit.Info) 
}
