import XCTest
@testable import StorageUtil

extension String: KeyPostfixProvider {
	public var keyPostfix: String { self }
}

extension Key {
	static let test: Self = "test"
}

final class StorageUtilTests: XCTestCase {
	func test () {
		Global.parameters.defaultLogHandler = DefaultLogHandler()
		let i = Item<Int>(key: .test)
		i.with(type: String.self)
		let item = i.key.item(type: Int.self).load()
//			.default(0)
//			.flagged()
	}
}
