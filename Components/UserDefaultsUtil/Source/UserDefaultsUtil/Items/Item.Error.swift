import Foundation



extension UserDefaultsUtil.Item {
	public enum Error: UserDefaultsUtilError {
		case itemNotFound
		case unexpectedError(Swift.Error)
	}
}



extension UserDefaultsUtil.Item.Error: CustomStringConvertible {
	public var description: String {
		let description: String
		
		switch self {
		case .itemNotFound:
			description = "Item not found"
		case .unexpectedError(let error):
			description = "Unexpected error - \(error.localizedDescription)"
		}
		
		return description
	}
}
