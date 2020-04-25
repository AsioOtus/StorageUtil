extension Keychain.GenericPassword {
	public struct Error: KeychainError {
		public let identifier: String
		public let keychainError: Keychain.Error
		
		internal init (_ identifier: String, _ keychainError: Keychain.Error) {
			self.identifier = identifier
			self.keychainError = keychainError
		}
	}
}



extension Keychain.GenericPassword.Error: Loggable {
	public var log: String { "\(identifier) – \(keychainError.log)" }
}
