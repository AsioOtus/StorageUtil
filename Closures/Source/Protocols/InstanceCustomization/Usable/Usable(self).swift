public extension Usable {
    mutating func useSelf (_ name: Any = "", in block: (inout Self) throws -> Void) rethrows {
		try block(&self)
	}
}

public extension Usable {
    mutating func useSelf <T1> (
		_ name: Any = "",
		with a: inout T1,
		in block: (inout Self, inout T1) throws -> Void
	) rethrows {
		try block(&self, &a)
	}
	
    mutating func useSelf <T1, T2> (
		_ name: Any = "",
		with a: inout T1,
		_ b: inout T2,
		in block: (inout Self, inout T1, inout T2) throws -> Void
	) rethrows {
		try block(&self, &a, &b)
	}
	
    mutating func useSelf <T1, T2, T3> (
		_ name: Any = "",
		with a: inout T1,
		_ b: inout T2,
		_ c: inout T3,
		in block: (inout Self, inout T1, inout T2, inout T3) throws -> Void
	) rethrows {
		try block(&self, &a, &b, &c)
	}
	
    mutating func useSelf <T1, T2, T3, T4> (
		_ name: Any = "",
		with a: inout T1,
		_ b: inout T2,
		_ c: inout T3,
		_ d: inout T4,
		in block: (inout Self, inout T1, inout T2, inout T3, inout T4) throws -> Void
	) rethrows {
		try block(&self, &a, &b, &c, &d)
	}
	
    mutating func useSelf <T1, T2, T3, T4, T5> (
		_ name: Any = "",
		with a: inout T1,
		_ b: inout T2,
		_ c: inout T3,
		_ d: inout T4,
		_ e: inout T5,
		in block: (inout Self, inout T1, inout T2, inout T3, inout T4, inout T5) throws -> Void
	) rethrows {
		try block(&self, &a, &b, &c, &d, &e)
	}
}

