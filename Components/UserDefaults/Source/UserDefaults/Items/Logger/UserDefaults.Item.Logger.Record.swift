import os

extension UserDefaults.Item.Logger {
	public struct Record {
		let operation: Operation
		let key: String
		
		init (_ operation: Operation, _ key: String) {
			self.operation = operation
			self.key = key
		}
		
		func commit (_ resolution: Resolution) -> Commit {
			let commit = Commit(
				record: self,
				resolution: resolution
			)
			
			return commit
		}
	}
}
