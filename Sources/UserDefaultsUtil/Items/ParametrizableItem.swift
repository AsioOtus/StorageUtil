import Foundation

open class ParametrizableItem <Value: Codable, KeyPostfixProviderType: KeyPostfixProvider> {
	internal let accessQueue: DispatchQueue
	internal let logger: Logger<Value>
	
	public let key: String
	public let storage: Storage
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ key: String,
		settings: Settings = .default,
		queue: DispatchQueue? = nil,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		let identificationInfo = IdentificationInfo(type: String(describing: Self.self), file: file, line: line, label: label)
		self.identificationInfo = identificationInfo
		
		self.key = key
		self.storage = settings.storage
		
		self.accessQueue = queue ?? DispatchQueue(label: "\(identificationInfo.typeDescription).\(key).accessQueue")
		self.logger = Logger(
			info: .init(
				keyPrefix: storage.keyPrefix,
				key: key,
				storage: storage.identificationInfo,
				item: identificationInfo
			),
			logHandler: settings.logHandler
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
}
