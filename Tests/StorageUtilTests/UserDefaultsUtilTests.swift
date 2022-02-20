import XCTest
@testable import StorageUtil

extension String: KeyPostfixProvider {
	public var keyPostfix: String { self }
}

final class StorageUtilTests: XCTestCase {
	func test () {
		Global.parameters.defaultLogHandler = DefaultLogHandler()
		
		let item = Item<Int>(key: "test")
			.flagable()
		
		item.delete()
		
//		item.save(nil)
		
		let bbb = item.load()
		print(bbb)
		
		item.saveWithFlag(22)
		
		print(item.load())
	}
	
	func testT () {
		let a = Int???(nil)
		
		if let b = a, case .none = b {
			print("A")
		} else {
			print("B")
		}
	}
}
