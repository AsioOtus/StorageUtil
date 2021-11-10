public struct UnexpectedError: StorageUtilError {
	public let error: Error
	
	internal init (_ error: Error) {
		self.error = error
	}
}
