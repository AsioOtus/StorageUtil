public protocol Transformable { }

public extension Transformable {
    func transform<T> (in block: (Self) throws -> T) rethrows -> T {
		let result = try block(self)
		return result
	}
}

public extension Transformable {
    func transform <T, T1> (
		_ name: Any = "",
		with a: T1,
		in block: (Self, T1) throws -> T
	) rethrows -> T {
		let result = try block(self, a)
		return result
	}
	
    func transform <T, T1, T2> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		in block: (Self, T1, T2) throws -> T
	) rethrows -> T {
		let result = try block(self, a, b)
		return result
	}
	
    func transform <T, T1, T2, T3> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		in block: (Self, T1, T2, T3) throws -> T
	) rethrows -> T {
		let result = try block(self, a, b, c)
		return result
	}
	
    func transform <T, T1, T2, T3, T4> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		_ d: T4,
		in block: (Self, T1, T2, T3, T4) throws -> T
	) rethrows -> T {
		let result = try block(self, a, b, c, d)
		return result
	}
	
    func transform <T, T1, T2, T3, T4, T5> (
		_ name: Any = "",
		with a: T1,
		_ b: T2,
		_ c: T3,
		_ d: T4,
		_ e: T5,
		in block: (Self, T1, T2, T3, T4, T5) throws -> T
	) rethrows -> T {
		let result = try block(self, a, b, c, d, e)
		return result
	}
}
