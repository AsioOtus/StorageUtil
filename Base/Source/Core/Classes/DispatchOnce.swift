import Foundation

class DispatchOnce {
	private(set) var isInitial = true
	
	let semaphore = DispatchSemaphore(value: 1)
	
	func perform (_ action: @escaping () -> Void) {
		semaphore.wait()
		
		guard isInitial else {
			semaphore.signal()
			return
		}
		
		isInitial = false
		semaphore.signal()
		
		action()
	}
}
