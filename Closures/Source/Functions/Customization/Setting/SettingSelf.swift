public func settingSelf <T1> (
	_ name: Any = "",
	_ a: inout T1,
	in block: (inout T1) throws -> Void
) rethrows -> T1 {
	try block(&a)
	return a
}

public func settingSelf <T1, T2> (
	_ name: Any = "",
	_ a: inout T1,
	_ b: inout T2,
	in block: (inout T1, inout T2) throws -> Void
) rethrows -> (T1, T2) {
	try block(&a, &b)
	return (a, b)
}

public func settingSelf <T1, T2, T3> (
	_ name: Any = "",
	_ a: inout T1,
	_ b: inout T2,
	_ c: inout T3,
	in block: (inout T1, inout T2, inout T3) throws -> Void
) rethrows -> (T1, T2, T3) {
	try block(&a, &b, &c)
	return (a, b, c)
}

public func settingSelf <T1, T2, T3, T4> (
	_ name: Any = "",
	_ a: inout T1,
	_ b: inout T2,
	_ c: inout T3,
	_ d: inout T4,
	in block: (inout T1, inout T2, inout T3, inout T4) throws -> Void
) rethrows -> (T1, T2, T3, T4) {
	try block(&a, &b, &c, &d)
	return (a, b, c, d)
}

public func settingSelf <T1, T2, T3, T4, T5> (
	_ name: Any = "",
	_ a: inout T1,
	_ b: inout T2,
	_ c: inout T3,
	_ d: inout T4,
	_ e: inout T5,
	in block: (inout T1, inout T2, inout T3, inout T4, inout T5) throws -> Void
) rethrows -> (T1, T2, T3, T4, T5) {
	try block(&a, &b, &c, &d, &e)
	return (a, b, c, d, e)
}
