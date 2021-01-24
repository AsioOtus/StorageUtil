import MultitoolBase_macOS
import Keychain_macOS
import UserDefaultsUtil_macOS
import LoggingUtil_macOS








// START ----- ----- ----- ----- -----

extension LogHandler {
	static let standard = LogHandler(prefix: "MTT", settings: .init(level: .trace))
}

let logger = LoggingUtil_macOS.Logger(level: .trace, source: "UserDefaultsUtil", logHandler: .standard)

extension LoggingUtil_macOS.Logger: UserDefaultsUtilLoggingProvider {
	public func userDefaultsUtilLog<ValueType>(_ info: UserDefaultsUtil_macOS.Logger.Info<ValueType>) {
		self.info(info.defaultMessage, source: info.userDefaultsItemTypeName)
	}
}

















Keychain.settings =
	.init(
		logging: .init(
			enable: true,
			level: .default,
			enableQueryLogging: true,
			enableValuesLogging: true,
			loggingProvider: DefaultKeychainLoggingProvider(prefix: "MTT")
		),
		genericPasswords: .init(
			itemIdentifierPrefixProvider: "com.multitool.testground",
			logging: .init(
				enable: true,
				level: .default,
				enableKeychainIdentifierLogging: true,
				enableQueryLogging: true,
				enableValuesLogging: true,
				loggingProvider: DefaultKeychainGenericPasswordsLoggingProvider(prefix: "MTT")
			)
		)
	)

UserDefaultsUtil_macOS.settings =
	.init(
		items: .init(
			itemKeyPrefixProvider: "com.multitool.testground"
		),
		logging: .init(
			enable: true,
			level: .default,
			enableValuesLogging: true,
			loggingProvider: Logger(level: .trace, source: "UserDefaultsUtil", logHandler: .standard)
		)
	)



let a = Keychain.GenericPassword<Int>("a", enableValueLogging: true)
try a.save(1)
_ = try a.isExists()

let b = try a.load()
print(b)

try a.delete()



let qwe = Keychain.ParametricGenericPassword<Int, String>("WWW", enableValueLogging: true)
try qwe.save(100, "qweqwe")

let wwww = Optional.some(0)

if case .none = wwww {
	 
} else {
	
}


let c = Item<String>("qwe")
c.save("qwe")
_ = c.isExists()

let d = c.load()
//print(d)

c.delete()





extension Int: UserDefaultsUtilItemKeyPostfixProvider {
	public var userDefaultsUtilItemPostfix: String {
		"sdf"
	}
}




let bb = DefaultableItem("qwe", StaticDefaultValueProvider<String>("zzz"))
//bb.save("")
_ = bb.isExists()

let rr = bb.load()
//print(rr)

bb.delete()
bb.saveDefaultIfNotExists()

bb.saveDefault()


class LOL: UserDefaultsUtilDefaultValueProvider, Codable {
	var tt = ""

	init (_ tt: String) {
		self.tt = tt
	}
}

extension Bool: UserDefaultsUtilDefaultValueProvider { }

var tttt = LOL("abc")


struct Kek {
	@UserDefaultsUtilDefaultableItem(key: "qweqweqwe", defaultValue: tttt) var qweqweqwe = LOL("abc")
}

let yyy = Kek().$qweqweqwe

print(yyy.defaultValue.tt)
tttt.tt = "rrrr"
print(yyy.defaultValue.tt)


Item<String>.Error.CodingError.jsonStringEncodingFailed(<#T##String#>)


// END ----- ----- ----- ----- -----



print()
print("END")
