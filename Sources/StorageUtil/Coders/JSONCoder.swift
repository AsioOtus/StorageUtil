import Foundation

public struct JSONCoder {
    static let `default` = Self()
    
    func encode <T: Encodable> (_ object: T) throws -> String {
        do {
            let jsonData = try JSONEncoder().encode(object)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else { throw Error.jsonDataDecodingFailed(jsonData.base64EncodedString()) }
            return jsonString
        } catch {
            throw Error(.encodingFailed(error))
        }
    }
    
    func decode <T: Decodable> (_ jsonString: String, _ type: T.Type) throws -> T {
        do {
            guard let jsonData = jsonString.data(using: .utf8) else { throw Error.jsonStringEncodingFailed(jsonString) }
            let object = try JSONDecoder().decode(type, from: jsonData)
            return object
        } catch {
            throw Error(.decodingFailed(error))
        }
    }
}


extension JSONCoder {
    public enum Error: StorageUtilError {
        case jsonDataDecodingFailed(String)
        case jsonStringEncodingFailed(String)
        
        case encodingFailed(Swift.Error)
        case decodingFailed(Swift.Error)
        
        private var innerError: Swift.Error? {
            let resultError: Swift.Error?
            
            switch self {
            case .encodingFailed(let error): fallthrough
            case .decodingFailed(let error):
                resultError = error
            default:
                resultError = nil
            }
            
            return resultError
        }
        
        public var description: String {
            let description: String
            
            switch self {
            case .jsonDataDecodingFailed(let jsonDataBase64):
                description = "UserDefaultsStorage.Coder – JSON data decoding failed – \(jsonDataBase64)"
            case .jsonStringEncodingFailed(let jsonString):
                description = "UserDefaultsStorage.Coder – JSON string encoding failed – \(jsonString)"
                
            case .encodingFailed(let error):
                description = "UserDefaultsStorage.Coder – Encoding error – \(error.localizedDescription)"
            case .decodingFailed(let error):
                description = "UserDefaultsStorage.Coder – Decoding error – \(error.localizedDescription)"
            }
            
            return description
        }
        
        public init (_ error: Self) {
            if let innerError = error.innerError as? Self {
                self = innerError
            } else {
                self = error
            }
        }
    }
}
