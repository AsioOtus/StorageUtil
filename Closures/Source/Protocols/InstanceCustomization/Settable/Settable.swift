public protocol Settable { }



public extension Settable {
	func set (_ name: Any = "", in block: (Self) throws -> Void) rethrows -> Self {
		try block(self)
		return self
	}
	
	func setCopy (_ name: Any = "", in block: (inout Self) throws -> Void) rethrows -> Self {
		var selfCopy = self
		try block(&selfCopy)
		return selfCopy
	}
	
	mutating func setSelf (in block: (inout Self) throws -> Void) rethrows -> Self {
		try block(&self)
		return self
	}
}
