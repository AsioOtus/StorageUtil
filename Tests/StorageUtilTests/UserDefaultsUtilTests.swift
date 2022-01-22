import XCTest
@testable import StorageUtil

final class StorageUtilTests: XCTestCase {
	func test () {
		let item = Item(key: "test")
			.initial(0)
			.default(10)
	}
}
