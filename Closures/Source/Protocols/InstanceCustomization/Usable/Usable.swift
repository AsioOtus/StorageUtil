public protocol Usable { }



public extension Usable {
	func use (_ name: Any = "", in block: (Self) throws -> Void) rethrows {
		try block(self)
	}
	
	func useCopy (_ name: Any = "", in block: (inout Self) throws -> Void) rethrows {
		var selfCopy = self
		try block(&selfCopy)
	}
	
	mutating func useSelf (_ name: Any = "", in block: (inout Self) throws -> Void) rethrows {
		try block(&self)
	}
}

