import Foundation

extension Keychain {
	public enum Error: KeychainError {
		case itemNotFound
		case itemIsNotData
		case savingFailed(OSStatus)
		case existingItemFound
		case loadingFailed(OSStatus)
		case deletingFailed(OSStatus)
		case existanceCheckFailed(OSStatus)
		
		case encodingFailed(Swift.Error)
		case decodingFailed(Swift.Error)
	}
}



extension Keychain.Error: Loggable {
	public var log: String {
		let log: String
		
		switch self {
		case .itemNotFound:
			log = "Item not found"
		case .itemIsNotData:
			log = "Item is not data"
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
		case .encodingFailed(let error):
			log = "Encoding failed: \(error)"
		case .decodingFailed(let error):
			log = "Decoding failed: \(error)"
		}
		
		return log
	}
}
