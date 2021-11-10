import XCTest
@testable import StorageUtil

final class StorageUtilTests: XCTestCase {
    func testGlobalSettings () {
		Settings.default = .init(storage: Settings.default.storage, logHandler: nil)
    }
}
