import Foundation

open class Item <Value: Codable> {
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
		
		self.accessQueue = queue ?? DispatchQueue(label: "\(identificationInfo.typeDescription).\(key).\(identificationInfo.instance).accessQueue")
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
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
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				
				return false
			}
		}
	}
}
