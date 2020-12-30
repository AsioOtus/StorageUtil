import Foundation



extension UserDefaultsUtil.Item.Coder {
	public enum Error: UserDefaultsUtilError {
		case jsonDataDecodingFailed(String)
		case jsonStringEncodingFailed(String)
		
		case encodingFailed(Swift.Error)
		case decodingFailed(Swift.Error)
		
		public var description: String {
			let description: String
			
			switch self {
			case .jsonDataDecodingFailed(let jsonDataBase64):
				description = "JSON data decoding failed – \(jsonDataBase64)"
			case .jsonStringEncodingFailed(let jsonString):
				description = "JSON string encoding failed – \(jsonString)"
				
			case .encodingFailed(let error):
				description = "Encoding error – \(error.localizedDescription)"
			case .decodingFailed(let error):
				description = "Decoding error – \(error.localizedDescription)"
			}
			
			return description
		}
	}
}



extension UserDefaultsUtil.Item {
	struct Coder {
		static func encode <T: Encodable> (_ object: T) throws -> String {
			do {
				let jsonData = try JSONEncoder().encode(object)
				guard let jsonString = String(data: jsonData, encoding: .utf8) else { throw Error.jsonDataDecodingFailed(jsonData.base64EncodedString()) }
				return jsonString
			} catch let error as Error {
				throw error
			} catch {
				throw Error.encodingFailed(error)
			}
		}
		
		static func decode <T: Decodable> (_ jsonString: String, _ type: T.Type) throws -> T {
			do {
				guard let jsonData = jsonString.data(using: .utf8) else { throw Error.jsonStringEncodingFailed(jsonString) }
				let object = try JSONDecoder().decode(type, from: jsonData)
				return object
			} catch let error as Error {
				throw error
			} catch {
				throw Error.decodingFailed(error)
			}
		}
	}
}
