import Foundation

extension UserDefaults.Item {
	public enum Error: Swift.Error {
		case itemNotFound
		case encodingFailed(Swift.Error)
		case decodingFailed(Swift.Error)
	}
}



extension UserDefaults.Item.Error: CustomStringConvertible {
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
