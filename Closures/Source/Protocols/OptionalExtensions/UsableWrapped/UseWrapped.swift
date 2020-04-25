public extension Optional {
	func useUnwrapped (_ name: Any = "", in block: (Wrapped) throws -> Void) rethrows {
		guard let selfValue = self else { return }
		try block(selfValue)
	}
	
	func setUnwrapped (_ name: Any = "", in block: (Wrapped) throws -> Void) rethrows -> Optional {
		guard let selfValue = self else { return nil }
		try block(selfValue)
		return self
	}
}
//
//public extension Optional {
//	func useUnwrapped <T1> (
//		_ name: Any = "",
//		with a: T1?,
//		in block: (Wrapped, T1) throws -> Void
//	) rethrows {
//		guard let value = self else { return }
//		guard let a = a else { return }
//		
//		try block(value, a)
//	}
//	
//	func useUnwrapped <T1, T2> (
//		_ name: Any = "",
//		with a: T1,
//		_ b: T2,
//		in block: (Self, T1, T2) throws -> Void
//		) rethrows {
//		try block(self, a, b)
//	}
//	
//	func useUnwrapped <T1, T2, T3> (
//		_ name: Any = "",
//		with a: T1,
//		_ b: T2,
//		_ c: T3,
//		in block: (Self, T1, T2, T3) throws -> Void
//		) rethrows {
//		try block(self, a, b, c)
//	}
//	
//	func useUnwrapped <T1, T2, T3, T4> (
//		_ name: Any = "",
//		with a: T1,
//		_ b: T2,
//		_ c: T3,
//		_ d: T4,
//		in block: (Self, T1, T2, T3, T4) throws -> Void
//		) rethrows {
//		try block(self, a, b, c, d)
//	}
//	
//	func useUnwrapped <T1, T2, T3, T4, T5> (
//		_ name: Any = "",
//		with a: T1,
//		_ b: T2,
//		_ c: T3,
//		_ d: T4,
//		_ e: T5,
//		in block: (Self, T1, T2, T3, T4, T5) throws -> Void
//		) rethrows {
//		try block(self, a, b, c, d, e)
//	}
//}
