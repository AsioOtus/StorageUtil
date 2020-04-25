public func transforming <T, T1> (
	_ name: Any = "",
	_ a: T1,
	in block: (T1) throws -> T
) rethrows -> T {
	let result = try block(a)
	return result
}

public func transforming <T, T1, T2> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	in block: (T1, T2) throws -> T
) rethrows -> T {
	let result = try block(a, b)
	return result
}

public func transforming <T, T1, T2, T3> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	_ c: T3,
	in block: (T1, T2, T3) throws -> T
) rethrows -> T {
	let result = try block(a, b, c)
	return result
}

public func transforming <T, T1, T2, T3, T4> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	_ c: T3,
	_ d: T4,
	in block: (T1, T2, T3, T4) throws -> T
) rethrows -> T {
	let result = try block(a, b, c, d)
	return result
}

public func transforming <T, T1, T2, T3, T4, T5> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	_ c: T3,
	_ d: T4,
	_ e: T5,
	in block: (T1, T2, T3, T4, T5) throws -> T
) rethrows -> T {
	let result = try block(a, b, c, d, e)
	return result
}
