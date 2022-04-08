import Foundation

public final class SingleValueStorage: Storage {
    public var value: String?
    
    public let keyPrefix: String?
    public let identificationInfo: IdentificationInfo
    
    public var logHandler: LogHandler? = nil
    
    public init <Value: Codable> (
        value: Value?,
        keyPrefix: String?,
        label: String? = nil,
        file: String = #fileID,
        line: Int = #line
    ) {
        self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
        
        self.value = try! JSONCoder.default.encode(value)
        self.keyPrefix = keyPrefix
    }
    
    public func prefixKey (_ key: Key) -> Key { key.add(prefix: keyPrefix) }
}

extension SingleValueStorage {
    @discardableResult
    public func logHandler (_ logHandler: LogHandler) -> Self {
        self.logHandler = logHandler
        return self
    }
}

extension SingleValueStorage {
    @discardableResult
    public func save <Value: Codable> (_ key: Key, _ value: Value) throws -> Value? {
        var details = LogRecord<Value>.Details(operation: "save")
        details.newValue = value
        defer {
            logHandler?.log(
                LogRecord<Value>(
                    info: .init(
                        keyPrefix: keyPrefix,
                        key: key,
                        storage: identificationInfo,
                        item: nil
                    ),
                    details: details
                )
            )
        }
        
        do {
            let oldValue = try? load(key, Value.self)
            
            details.oldValue = oldValue
            details.existance = oldValue != nil
            
            let valueJsonString = try JSONCoder.default.encode(value)
            self.value = valueJsonString
            
            return oldValue
        } catch {
            details.error = Error(description: error.localizedDescription)
            
            throw error
        }
    }
    
    public func load <Value: Codable> (_ key: Key, _ type: Value.Type) throws -> Value? {
        var details = LogRecord<Value>.Details(operation: "load")
        defer {
            logHandler?.log(
                LogRecord<Value>(
                    info: .init(
                        keyPrefix: keyPrefix,
                        key: key,
                        storage: identificationInfo,
                        item: nil
                    ),
                    details: details
                )
            )
        }
        
        do {            
            guard let valueJsonString = value else { return nil }
            let value = try JSONCoder.default.decode(valueJsonString, type)
            
            details.oldValue = value
            details.existance = true
            
            return value
        } catch {
            details.existance = false
            details.error = Error(description: error.localizedDescription)
            
            throw error
        }
    }
    
    public func delete <Value: Codable> (_ key: Key, _ type: Value.Type) -> Value? {
        var details = LogRecord<Value>.Details(operation: "delete")
        defer {
            logHandler?.log(
                LogRecord<Value>(
                    info: .init(
                        keyPrefix: keyPrefix,
                        key: key,
                        storage: identificationInfo,
                        item: nil
                    ),
                    details: details
                )
            )
        }
        
        let oldValue = try? load(key, type)
        value = nil
        
        details.oldValue = oldValue
        details.existance = oldValue != nil
        
        return oldValue
    }
}
