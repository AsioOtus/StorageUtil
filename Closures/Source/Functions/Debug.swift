public func debug (_ name: Any = "", _ block: () -> ()) {
	#if RELEASE
	#warning("\"debug\" function is using in release mode.")
	#endif
	
	#if DEBUG
	block()
	#endif
}
