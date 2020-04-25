public func using <T1> (
	_ name: Any = "",
	_ a: T1,
	in block: (T1) throws -> Void
) rethrows {
	try block(a)
}

public func using <T1, T2> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	in block: (T1, T2) throws -> Void
) rethrows {
	try block(a, b)
}

public func using <T1, T2, T3> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	_ c: T3,
	in block: (T1, T2, T3) throws -> Void
) rethrows {
	try block(a, b, c)
}

public func using <T1, T2, T3, T4> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	_ c: T3,
	_ d: T4,
	in block: (T1, T2, T3, T4) throws -> Void
) rethrows {
	try block(a, b, c, d)
}

public func using <T1, T2, T3, T4, T5> (
	_ name: Any = "",
	_ a: T1,
	_ b: T2,
	_ c: T3,
	_ d: T4,
	_ e: T5,
	in block: (T1, T2, T3, T4, T5) throws -> Void
) rethrows {
	try block(a, b, c, d, e)
}
