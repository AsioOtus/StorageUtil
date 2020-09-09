class SingleProcessor {
	private lazy var processingQueue = DispatchQueue(label: "SingleProcessor.processingQueue.\(uuid)")
	private(set) var isFree = true
	let uuid = UUID()
	
	func process (_ action: @escaping (_ completion: @escaping () -> Void) -> Void) {
		processingQueue.sync {
			guard isFree else { return }
			isFree = false
			
			action {
				self.isFree = true
			}
		}
	}
}
