public extension Settable {
    func setCopy <T1> (
		_ name: Any = "",
		with a: T1,
		in block: (inout Self, inout T1) throws -> Void
	) rethrows -> Self {
		var selfCopy = self
		var aCopy = a
		
		try block(&selfCopy, &aCopy)
		return selfCopy
	}
	
    func setCopy <T1, T2> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		in block: (inout Self, inout T1, inout T2) throws -> Void
	) rethrows -> Self {
		var selfCopy = self
		var aCopy = a
		var bCopy = b
		
		try block(&selfCopy, &aCopy, &bCopy)
		return selfCopy
	}
	
    func setCopy <T1, T2, T3> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		in block: (inout Self, inout T1, inout T2, inout T3) throws -> Void
	) rethrows -> Self {
		var selfCopy = self
		var aCopy = a
		var bCopy = b
		var cCopy = c
		
		try block(&selfCopy, &aCopy, &bCopy, &cCopy)
		return selfCopy
	}
	
    func setCopy <T1, T2, T3, T4> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		_ d: T4,
		in block: (inout Self, inout T1, inout T2, inout T3, inout T4) throws -> Void
	) rethrows -> Self {
		var selfCopy = self
		var aCopy = a
		var bCopy = b
		var cCopy = c
		var dCopy = d
		
		try block(&selfCopy, &aCopy, &bCopy, &cCopy, &dCopy)
		return selfCopy
	}
	
    func setCopy <T1, T2, T3, T4, T5> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		_ d: T4,
		_ e: T5,
		in block: (inout Self, inout T1, inout T2, inout T3, inout T4, inout T5) throws -> Void
	) rethrows -> Self {
		var selfCopy = self
		var aCopy = a
		var bCopy = b
		var cCopy = c
		var dCopy = d
		var eCopy = e
		
		try block(&selfCopy, &aCopy, &bCopy, &cCopy, &dCopy, &eCopy)
		return selfCopy
	}
}
