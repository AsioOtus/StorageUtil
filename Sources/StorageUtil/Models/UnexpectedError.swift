public struct UnexpectedError: StorageUtilError {
	public let error: Error
		
	public var description: String { "\(Info.moduleName) – Unexpected error – \(error)" }
	
	internal init (_ error: Error) {
		self.error = error
	}
}
