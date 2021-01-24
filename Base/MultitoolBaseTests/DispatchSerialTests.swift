import XCTest

class DispatchSerialTests: XCTestCase {
	override func setUpWithError() throws {
		print()
		print()
	}
	
	override func tearDownWithError() throws {
		print()
		print()
	}
	
	func testPerfoming () {
		let serial = DispatchSerial()
		
		serial.perform { comletion in
			self.asyncFunc(comletion)
		}
		
		serial.perform { comletion in
			self.asyncFunc(comletion)
		}
		
		serial.perform { comletion in
			self.asyncFunc(comletion)
		}
		
		print("All funcs called")
	}
	
	func testPlainPerfoming () {
		let serial = DispatchSerial()
		
		serial.perform {
			self.asyncFunc({ })
		}
		
		serial.perform {
			self.asyncFunc({ })
		}
		
		serial.perform {
			self.asyncFunc({ })
		}
		
		print("All funcs called")
	}
	
	func testSomething () {
		let serial = DispatchSerial()
		let single = DispatchSingle()
				
		let q = DispatchQueue(label: "q", attributes: .concurrent)
		let qq = (0..<10).map { DispatchQueue(label: "qweqwe.\($0)", attributes: .concurrent) }
		
		for i in 0..<10 {
			for (ii, qq) in qq.enumerated() {
				q.async {
					serial.perform {
					for iii in 0..<10 {
						qq.async {
							serial.perform {
								self.task("\(i).\(ii).\(iii)")
							}
						}
						}
					}
				}
			}
		}
		
		
		
		
//		DispatchQueue.concurrentPerform(iterations: 10) { i in
//			for ii in 1...10 {
//				qq[i].async {
////					serial.perform {
//						self.task("\(i).\(ii)")
////					}
//				}
//			}
//		}
		
//		for (i, q) in aa.enumerated() {
//			for ii in 1...100 {
//				q.async {
//					self.task("\(i).\(ii)")
//				}
//			}
//		}
		
		
		
		let group = DispatchGroup()
		group.enter()
		group.wait(timeout: .now() + 200)
		
	}
}



private extension DispatchSerialTests {
	func task (_ text: String) {
		for i in 0...10 {
			print("\(text)-\(i)", terminator: " ")
		}
		
		print()
	}
	
	func asyncFunc (_ completion: @escaping () -> ()) {
		print("Async func start")
		
		DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
			print("Async func finished")
			completion()
		}
	}
}
