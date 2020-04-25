import Foundation

public extension UserDefaults {
	struct Error: Swift.Error {
		public let category: Category
		
		internal init (_ category: Category) {
			self.category = category
		}
		
		public enum Category {
			case encodingFailed(Swift.Error)
			case decodingFailed(Swift.Error)
		}
	}
}
