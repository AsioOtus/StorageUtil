import XCTest

class MultitoolBaseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func test2 () {
		let serial = DispatchSerial()
		let queue = DispatchQueue(label: "qwe", attributes: .concurrent)
		let group = DispatchGroup()
		group.enter()
		queue.async {
			serial.perform {
				print("1")
			}
		}
		
		queue.async {
			print("2")
		}
		
		queue.async {
			print("3")
		}

		queue.async {
			print("4")
		}
	}
	
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

	private func asyncFunc (_ completion: @escaping () -> ()) {
		print("Request")

		DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
			print("Response")
			completion()
		}
	}
}
