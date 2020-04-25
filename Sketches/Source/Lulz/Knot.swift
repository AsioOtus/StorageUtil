func a (_ b: @escaping (() -> ()) -> ()) -> (() -> ()) -> () { { { (i: () -> ()) in b(i) } }() }
(a { print("1"); $0(); print("2") }) { print("3") }


let b: (_ b: @escaping (() -> ()) -> ()) -> (() -> ()) -> () = { j in { { (i: () -> ()) in j(i) } }() }
(b { print("1"); $0(); print("2") }) { print("3") }
