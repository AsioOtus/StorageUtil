public func transformSelf <T, T1> (
	_ name: Any = "",
	_ a: inout T1,
	in block: (inout T1) throws -> T
) rethrows -> T {
	let result = try block(&a)
	return result
}

public func transformSelf <T, T1, T2> (
	_ name: Any = "",
	_ a: inout T1,
	_ b: inout T2,
	in block: (inout T1, inout T2) throws -> T
) rethrows -> T {
	let result = try block(&a, &b)
	return result
}

public func transformSelf <T, T1, T2, T3> (
	_ name: Any = "",
	_ a: inout T1,
	_ b: inout T2,
	_ c: inout T3,
	in block: (inout T1, inout T2, inout T3) throws -> T
) rethrows -> T {
	let result = try block(&a, &b, &c)
	return result
}

public func transformSelf <T, T1, T2, T3, T4> (
	_ name: Any = "",
	_ a: inout T1,
	_ b: inout T2,
	_ c: inout T3,
	_ d: inout T4,
	in block: (inout T1, inout T2, inout T3, inout T4) throws -> T
) rethrows -> T {
	let result = try block(&a, &b, &c, &d)
	return result
}

public func transformSelf <T, T1, T2, T3, T4, T5> (
	_ name: Any = "",
	_ a: inout T1,
	_ b: inout T2,
	_ c: inout T3,
	_ d: inout T4,
	_ e: inout T5,
	in block: (inout T1, inout T2, inout T3, inout T4, inout T5) throws -> T
) rethrows -> T {
	let result = try block(&a, &b, &c, &d, &e)
	return result
}
