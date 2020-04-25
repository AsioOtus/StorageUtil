public extension Transformable {
    mutating func transformSelf<T> (in block: (inout Self) throws -> T) rethrows -> T {
		let result = try block(&self)
		return result
	}
}

public extension Transformable {
    mutating func transformSelf <T, T1> (
		_ name: Any = "",
		with a: inout T1,
		in block: (inout Self, inout T1) throws -> T
	) rethrows -> T {
		let result = try block(&self, &a)
		return result
	}
	
    mutating func transformSelf <T, T1, T2> (
		_ name: Any = "",
		with a: inout T1,
		_ b: inout T2,
		in block: (inout Self, inout T1, inout T2) throws -> T
	) rethrows -> T {
		let result = try block(&self, &a, &b)
		return result
	}
	
    mutating func transformSelf <T, T1, T2, T3> (
		_ name: Any = "",
		with a: inout T1,
		_ b: inout T2,
		_ c: inout T3,
		in block: (inout Self, inout T1, inout T2, inout T3) throws -> T
	) rethrows -> T {
		let result = try block(&self, &a, &b, &c)
		return result
	}
	
    mutating func transformSelf <T, T1, T2, T3, T4> (
		_ name: Any = "",
		with a: inout T1,
		_ b: inout T2,
		_ c: inout T3,
		_ d: inout T4,
		in block: (inout Self, inout T1, inout T2, inout T3, inout T4) throws -> T
	) rethrows -> T {
		let result = try block(&self, &a, &b, &c, &d)
		return result
	}
	
    mutating func transformSelf <T, T1, T2, T3, T4, T5> (
		_ name: Any = "",
		with a: inout T1,
		_ b: inout T2,
		_ c: inout T3,
		_ d: inout T4,
		_ e: inout T5,
		in block: (inout Self, inout T1, inout T2, inout T3, inout T4, inout T5) throws -> T
	) rethrows -> T {
		let result = try block(&self, &a, &b, &c, &d, &e)
		return result
	}
}
