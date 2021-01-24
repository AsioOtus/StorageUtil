let loggingHandler = LoggingHandler(prefix: "TSIApp", settings: .init(level: .trace, enableSourceCodeInfo: false))
let logger = Logger(source: "NetworkUtil", loggingHandler)

let address = "tsi.lv/GetItems"

struct TSI {
	struct Requests {
		struct GetItems {
			func a () {
				print(String(reflecting: Self.self))
			}
		}
	}
}

TSI.Requests.GetItems().a()

logger.trace("\(String(describing: TSI.Requests.GetItems.self)) | REQUEST | \(address)")
logger.trace("\(String(describing: TSI.Requests.GetItems.self)) | RESPONSE | \(address)")
