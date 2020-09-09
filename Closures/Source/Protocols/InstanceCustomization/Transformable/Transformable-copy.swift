public extension Transformable {
    func transformCopy <T, T1> (
		_ name: Any = "",
		with a: T1,
		in block: (inout Self, inout T1) throws -> T
	) rethrows -> T {
		var selfCopy = self
		var aCopy = a
		
		let result = try block(&selfCopy, &aCopy)
		return result
	}
	
    func transformCopy <T, T1, T2> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		in block: (inout Self, inout T1, inout T2) throws -> T
	) rethrows -> T {
		var selfCopy = self
		var aCopy = a
		var bCopy = b
		
		let result = try block(&selfCopy, &aCopy, &bCopy)
		return result
	}
	
    func transformCopy <T, T1, T2, T3> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		in block: (inout Self, inout T1, inout T2, inout T3) throws -> T
	) rethrows -> T {
		var selfCopy = self
		var aCopy = a
		var bCopy = b
		var cCopy = c
		
		let result = try block(&selfCopy, &aCopy, &bCopy, &cCopy)
		return result
	}
	
    func transformCopy <T, T1, T2, T3, T4> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		_ d: T4,
		in block: (inout Self, inout T1, inout T2, inout T3, inout T4) throws -> T
	) rethrows -> T {
		var selfCopy = self
		var aCopy = a
		var bCopy = b
		var cCopy = c
		var dCopy = d
		
		let result = try block(&selfCopy, &aCopy, &bCopy, &cCopy, &dCopy)
		return result
	}
	
    func transformCopy <T, T1, T2, T3, T4, T5> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		_ d: T4,
		_ e: T5,
		in block: (inout Self, inout T1, inout T2, inout T3, inout T4, inout T5) throws -> T
	) rethrows -> T {
		var selfCopy = self
		var aCopy = a
		var bCopy = b
		var cCopy = c
		var dCopy = d
		var eCopy = e
		
		let result = try block(&selfCopy, &aCopy, &bCopy, &cCopy, &dCopy, &eCopy)
		return result
	}
}
