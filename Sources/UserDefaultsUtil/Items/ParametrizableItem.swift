import Foundation

open class ParametrizableItem <Value: Codable, KeyPostfixProviderType: KeyPostfixProvider> {
	internal let accessQueue: DispatchQueue
	internal let logger: Logger<Value>
	
	public let key: String
	public let storage: Storage
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ key: String,
		storage: Storage = DefaultInstances.storage,
		logHandler: LogHandler? = DefaultInstances.logHandler,
		queue: DispatchQueue? = nil,
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		let identificationInfo = IdentificationInfo(typeId: String(describing: Self.self), file: file, line: line, alias: alias)
		self.identificationInfo = identificationInfo
		
		self.key = key
		self.storage = storage
		
		self.accessQueue = queue ?? DispatchQueue(label: "\(identificationInfo.typeDescription).\(key).accessQueue")
		self.logger = Logger(
			info: .init(
				storageKeyPrefix: storage.keyPrefix,
				key: key,
				storageIdentificationInfo: storage.identificationInfo,
				itemIdentificationInfo: identificationInfo
			),
			logHandler: logHandler
		)
	}
}

extension ParametrizableItem {
	@discardableResult
	public func save (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "save")
			details.newValue = value
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				let oldValue = try storage.save(postfixedKey, value)
				
				details.oldValue = oldValue
				details.existance = oldValue != nil
				
				return true
			} catch {
				details.error = StandardStorage.Error(.unexpectedError(error))				
				return false
			}
		}
	}
	
	public func load (_ keyPostfixProvider: KeyPostfixProviderType) -> Value? {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "load")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				let value = try storage.load(postfixedKey, Value.self)
				
				details.oldValue = value
				details.existance = value != nil
				
				return value
			} catch {
				details.existance = false
				details.error = StandardStorage.Error(.unexpectedError(error))
				
				return nil
			}
		}
	}
	
	public func delete (_ keyPostfixProvider: KeyPostfixProviderType) {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "delete")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			let value = storage.delete(postfixedKey, Value.self)
			
			details.oldValue = value
			details.existance = value != nil
		}
	}
	
	public func isExists (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "is exists")
			details.keyPostfix = keyPostfix
			defer { logger.log(details) }
			
			do {
				let value = try storage.load(postfixedKey, Value.self)
				
				details.oldValue = value
				details.existance = value != nil
				
				return value != nil
			} catch {
				details.existance = false
				details.error = StandardStorage.Error(.unexpectedError(error))
				
				return false
			}
		}
	}
}
