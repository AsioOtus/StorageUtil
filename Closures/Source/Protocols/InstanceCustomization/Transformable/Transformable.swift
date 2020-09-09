public protocol Transformable { }



public extension Transformable {
	func transform<T> (in block: (Self) throws -> T) rethrows -> T {
		let result = try block(self)
		return result
	}
	
	func transformCopy<T> (in block: (inout Self) throws -> T) rethrows -> T {
		var selfCopy = self
		let result = try block(&selfCopy)
		return result
	}
	
	mutating func transformSelf<T> (in block: (inout Self) throws -> T) rethrows -> T {
		let result = try block(&self)
		return result
	}
}
