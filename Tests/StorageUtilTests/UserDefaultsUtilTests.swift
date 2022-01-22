import XCTest
@testable import StorageUtil

final class StorageUtilTests: XCTestCase {
	func test () {
		let item = Item<Int>(key: "test").withInitialization(0).defaultable(10)
	}
}
