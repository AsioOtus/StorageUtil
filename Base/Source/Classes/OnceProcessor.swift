class OnceProcessor {
	private lazy var processingQueue = DispatchQueue(label: "OnceProcessor.processingQueue.\(uuid)")
	private(set) var isProcessed = false
	let uuid = UUID()
	
	func process (_ action: () -> ()) {
		processingQueue.sync {
			guard !isProcessed else { return }
			
			isProcessed = true
			
			action()
		}
	}
}
