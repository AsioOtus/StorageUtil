import Foundation

extension UserDefaults {
	public enum Error: Swift.Error, UserDefaultsLoggable {
		case encodingFailed(Swift.Error)
		case decodingFailed(Swift.Error)
		
		public var userDefaultsLog: String {
			let log: String
			
			switch self {
			case .encodingFailed(let error):
				log = error.localizedDescription
			case .decodingFailed(let error):
				log = error.localizedDescription
			}
			
			return log
		}
	}
}
