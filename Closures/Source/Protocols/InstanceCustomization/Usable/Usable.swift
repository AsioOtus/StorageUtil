public protocol Usable { }

public extension Usable {
    func use (_ name: Any = "", in block: (Self) throws -> Void) rethrows {
		try block(self)
	}
}

public extension Usable {
    func use <T1> (
		_ name: Any = "",
		with a: T1,
		in block: (Self, T1) throws -> Void
	) rethrows {
		try block(self, a)
	}
	
    func use <T1, T2> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		in block: (Self, T1, T2) throws -> Void
	) rethrows {
		try block(self, a, b)
	}
	
    func use <T1, T2, T3> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		in block: (Self, T1, T2, T3) throws -> Void
	) rethrows {
		try block(self, a, b, c)
	}
	
    func use <T1, T2, T3, T4> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		_ d: T4,
		in block: (Self, T1, T2, T3, T4) throws -> Void
	) rethrows {
		try block(self, a, b, c, d)
	}
	
    func use <T1, T2, T3, T4, T5> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		_ d: T4,
		_ e: T5,
		in block: (Self, T1, T2, T3, T4, T5) throws -> Void
	) rethrows {
		try block(self, a, b, c, d, e)
	}
}
