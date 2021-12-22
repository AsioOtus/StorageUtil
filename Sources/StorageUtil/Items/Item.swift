import Foundation

open class Item <Value: Codable> {
	internal let accessQueue: DispatchQueue
	internal let logger: Logger<Value>
	
	public let key: String
	public let storage: Storage
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ key: String,
		storage: Storage = Global.storage,
		logHandler: LogHandler? = Global.logHandler,
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

extension Item {
	private static var changesFlagKeyPrefix: String { "changesFlag" }
	
	@discardableResult
	public func initial (_ initialValue: Value) -> Self {
		let changesFlagKey = KeyBuilder.build(prefix: Self.changesFlagKeyPrefix, key: key)
		
		let changesFlag = try? storage.load(changesFlagKey, Bool.self)
		if changesFlag == nil || changesFlag == false {
			_ = try? storage.save(key, initialValue)
		}
		
		return self
	}

	@discardableResult
	public func resetInitial () -> Self {
		let changesFlagKey = KeyBuilder.build(prefix: Self.changesFlagKeyPrefix, key: key)
		_ = try? storage.delete(changesFlagKey, Bool.self)
		return self
	}
	
	internal func setChangesFlag () throws {
		let changesFlagKey = KeyBuilder.build(prefix: Self.changesFlagKeyPrefix, key: key)
		_ = try storage.save(changesFlagKey, true)
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
				
				try setChangesFlag()
				
				return true
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
				return false
			}
		}
	}
	
	@discardableResult
	public func saveIfNotExist (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save if not exist")
			defer { logger.log(details) }
			
			do {
				if let oldValue = try? storage.load(key, Value.self) {
					details.oldValue = oldValue
					details.existance = true
					details.comment = "old value preserved"
					
					return true
				} else {
					details.newValue = value
					
					let oldValue = try storage.save(key, value)
					
					details.oldValue = oldValue
					details.existance = oldValue != nil
					details.comment = "value saved"
					
					try setChangesFlag()
					
					return true
				}
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
			
			do {
				let value = try storage.delete(key, Value.self)
				
				details.oldValue = value
				details.existance = value != nil
			
				try setChangesFlag()
			} catch {
				details.error = (error as? StorageUtilError) ?? UnexpectedError(error)
			}
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
