import Foundation

extension Keychain {
	public enum Error: KeychainError {
		case itemNotFound
		case nilItem
		case savingFailed(OSStatus)
		case existingItemFound
		case loadingFailed(OSStatus)
		case deletingFailed(OSStatus)
		case existanceCheckFailed(OSStatus)
		case classCLearingFailed(Class, OSStatus)
	}
}



extension Keychain.Error: Loggable {
	public var log: String {
		let log: String
		
		switch self {
		case .itemNotFound:
			log = "Item not found"
		case .nilItem:
			log = "Item is nil"
		case .savingFailed(let status):
			log = "Saving failed: \(status.log)"
		case .existingItemFound:
			log = "Existing item found"
		case .loadingFailed(let status):
			log = "Loading failed: \(status.log)"
		case .deletingFailed(let status):
			log = "Deletion failed: \(status.log)"
		case .existanceCheckFailed(let status):
			log = "Existance check failed: \(status.log)"
		case .classCLearingFailed(let keychainClass, let status):
			log = "Class clearing failed: \(keychainClass.name) – \(status.log)"
		}
		
		return log
	}
}
