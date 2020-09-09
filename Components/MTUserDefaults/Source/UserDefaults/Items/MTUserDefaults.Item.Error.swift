import Foundation

extension MTUserDefaults.Item {
	public enum Error: Swift.Error {
		case itemNotFound
		case encodingFailed(Swift.Error)
		case decodingFailed(Swift.Error)
	}
}



extension MTUserDefaults.Item.Error: CustomStringConvertible {
	public var description: String {
		let description: String
		
		switch self {
		case .itemNotFound:
			description = "Item not found"
		case .encodingFailed(let error):
			description = "Encoding error – \(error.localizedDescription)"
		case .decodingFailed(let error):
			description = "Decoding error – \(error.localizedDescription)"
		}
		
		return description
	}
}
