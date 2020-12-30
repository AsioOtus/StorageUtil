import Foundation



extension UserDefaultsUtil {
	open class DefautableItem <Value: Codable, DefaultValueProvider: UserDefaultsUtilDefaultValueProvider>: Item<Value> where DefaultValueProvider.Value == Value {
		private lazy var accessQueue = DispatchQueue(label: "\(Self.self).\(key).accessQueue")
		private lazy var logger = Logger(String(describing: Self.self))
		
		public let defaultValueProvider: DefaultValueProvider
		
		public var defaultValue: Value { defaultValueProvider.userDefaultsUtilDefaultValue }
		
		public init (_ shortKey: String, _ defaultValueProvider: DefaultValueProvider, _ userDefaultsInstance: UserDefaults = .standard) {
			self.defaultValueProvider = defaultValueProvider
			super.init(shortKey, userDefaultsInstance)
		}
	}
}



public extension UserDefaultsUtil.DefautableItem {
	func loadOrDefault () -> Value {
		let (value, logCommit) = loadOrDefault(nil)
		logger.log(logCommit)
		return value
	}
	
	@discardableResult
	func saveDefault () -> Bool {
		let (isSuccess, logCommit) = saveDefault(nil)
		logger.log(logCommit)
		return isSuccess
	}
	
	@discardableResult
	func saveDefaultIfNotExists () -> Bool {
		let (isSuccess, logCommit) = saveDefaultIfNotExists(nil)
		logger.log(logCommit)
		return isSuccess
	}
}



internal extension UserDefaultsUtil.DefautableItem {
	func loadOrDefault (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (Value, UserDefaultsUtil.Logger.Commit<Value>) {
		var (value, logCommit) = load(keyPostfixProvider)
		
		logCommit.operation = "LOAD OR DEFAULT"
		
		let finalValue: Value
		if let value = value {
			finalValue = value
		} else {
			let defaultValue = defaultValueProvider.userDefaultsUtilDefaultValue
			finalValue = defaultValue
			logCommit.additional = "default value used – \(defaultValue)"
		}
		
		return (finalValue, logCommit)
	}
	
	@discardableResult
	func saveDefault (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (Bool, UserDefaultsUtil.Logger.Commit<Value>) {
		var (isSavingSucceeded, logCommit) = save(defaultValueProvider.userDefaultsUtilDefaultValue, keyPostfixProvider)
		
		logCommit.operation = "SAVE DEFAULT"
		
		return (isSavingSucceeded, logCommit)
	}
	
	@discardableResult
	func saveDefaultIfNotExists (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (Bool, UserDefaultsUtil.Logger.Commit<Value>) {
		accessQueue.sync {
			var (existance, logCommit) = isExists(keyPostfixProvider)
			
			guard !existance else {
				logCommit.operation = "SAVE DEFAULT IF NOT EXISTS"
				return (true, logCommit)
			}
			
			var (isSavingSucceeded, saveLogCommit) = saveDefault(keyPostfixProvider)
			
			saveLogCommit.operation = "SAVE DEFAULT IF NOT EXISTS"
			
			return (isSavingSucceeded, saveLogCommit)
		}
	}
}
