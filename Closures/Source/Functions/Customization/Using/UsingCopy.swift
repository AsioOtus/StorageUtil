public func usingCopy <T1> (
	_ name: Any = "",
	_ a: T1,
	in block: (inout T1) throws -> Void
) rethrows {
	var aCopy = a
	
	try block(&aCopy)
}

public func usingCopy <T1, T2> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	in block: (inout T1, inout T2) throws -> Void
) rethrows {
	var aCopy = a
	var bCopy = b
	
	try block(&aCopy, &bCopy)
}

public func usingCopy <T1, T2, T3> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	_ c: T3,
	in block: (inout T1, inout T2, inout T3) throws -> Void
) rethrows {
	var aCopy = a
	var bCopy = b
	var cCopy = c
	
	try block(&aCopy, &bCopy, &cCopy)
}

public func usingCopy <T1, T2, T3, T4> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	_ c: T3,
	_ d: T4,
	in block: (inout T1, inout T2, inout T3, inout T4) throws -> Void
) rethrows {
	var aCopy = a
	var bCopy = b
	var cCopy = c
	var dCopy = d
	
	try block(&aCopy, &bCopy, &cCopy, &dCopy)
}

public func usingCopy <T1, T2, T3, T4, T5> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	_ c: T3,
	_ d: T4,
	_ e: T5,
	in block: (inout T1, inout T2, inout T3, inout T4, inout T5) throws -> Void
) rethrows {
	var aCopy = a
	var bCopy = b
	var cCopy = c
	var dCopy = d
	var eCopy = e
	
	try block(&aCopy, &bCopy, &cCopy, &dCopy, &eCopy)
}
