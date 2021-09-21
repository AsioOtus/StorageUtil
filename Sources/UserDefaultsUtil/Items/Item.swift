import Foundation

open class Item <Value: Codable> {
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

extension Item {
	@discardableResult
	public func save (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save")
			details.newValue = value
			defer { logger.log(details) }
			
			do {
				let oldValue = try storage.save(key, value)
				
				details.oldValue = oldValue
				details.existance = oldValue != nil
				
				return true
			} catch {
				details.error = StandardStorage.Error(.unexpectedError(error))
				return false
			}
		}
	}
	
	public func load () -> Value? {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "load")
			defer { logger.log(details) }
			
			do {
				let value = try storage.load(key, Value.self)
				
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
	
	public func delete () {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "delete")
			defer { logger.log(details) }
			
			let value = storage.delete(key, Value.self)
			
			details.oldValue = value
			details.existance = value != nil
		}
	}
	
	public func isExists () -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "is exists")
			defer { logger.log(details) }
			
			do {
				let value = try storage.load(key, Value.self)
				
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
