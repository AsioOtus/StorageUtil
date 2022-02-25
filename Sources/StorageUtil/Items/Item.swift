import Foundation

public struct Item <Value: Codable>: ItemProtocol {
	public let key: Key
	public let storage: Storage

	public let accessQueue: DispatchQueue
	public let logger: Logger<Value>
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		key: Key,
		storage: Storage = Global.parameters.defaultStorage,
		logHandler: LogHandler? = Global.parameters.defaultLogHandler,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		let identificationInfo = IdentificationInfo(type: String(describing: Self.self), file: file, line: line, label: label, extra: "Key: \(key)")
		self.identificationInfo = identificationInfo
		
		self.key = key
		self.storage = storage
		
		self.accessQueue = DispatchQueue(label: "\(identificationInfo.typeDescription).\(key).\(identificationInfo.instance).accessQueue")
		self.logger = Logger(
			info: .init(
				keyPrefix: storage.keyPrefix,
				key: key,
				storage: storage.identificationInfo,
				item: identificationInfo
			),
			logHandler: logHandler
		)
	}
}

public extension Item {
	func save (_ key: Key, _ value: Value) throws -> Value? { try storage.save(key, value) }
	func load (_ key: Key) throws -> Value? { try storage.load(key, Value.self) }
	func delete (_ key: Key) throws -> Value? { try storage.delete(key, Value.self) }
}

public extension Item {
	@discardableResult
	func save (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save")
			details.newValue = value
			defer { logger.log(details) }
			
			do {
				let oldValue = try save(key, value)
				
				details.oldValue = oldValue
				details.existance = oldValue != nil
				
				return true
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
	
	@discardableResult
	func saveIfExists (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save if exist")
			defer { logger.log(details) }
			
			do {
				if (try? load(key)) != nil {
					details.newValue = value
					
					let oldValue = try save(key, value)
					
					details.oldValue = oldValue
					details.existance = oldValue != nil
					details.comment = "value saved"
					
					return true
				} else {
					details.existance = false
					details.comment = "value not exists preserved"
					
					return true
				}
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
	
	@discardableResult
	func saveIfNotExists (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save if not exist")
			defer { logger.log(details) }
			
			do {
				if let oldValue = try? load(key) {
					details.oldValue = oldValue
					details.existance = true
					details.comment = "old value preserved"
					
					return true
				} else {
					details.newValue = value
					
					let oldValue = try save(key, value)
					
					details.oldValue = oldValue
					details.existance = oldValue != nil
					details.comment = "value saved"
					
					return true
				}
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
	
	func load () -> Value? {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "load")
			defer { logger.log(details) }
			
			do {
				let value = try load(key)
				
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
	
	func delete () -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "delete")
			defer { logger.log(details) }
			
			do {
				let value = try delete(key)
				
				details.oldValue = value
				details.existance = value != nil
				
				return true
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				
				return false
			}
		}
	}
	
	func isExists () -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "is exists")
			defer { logger.log(details) }
			
			do {
				let value = try load(key)
				
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

public extension Item {
	func with <NewValue: Codable> (type: NewValue.Type, label: String? = nil, file: String = #fileID, line: Int = #line) -> Item<NewValue> {
		.init(key: key, storage: storage, logHandler: logger.logHandler, label: label, file: file, line: line)
	}
}
