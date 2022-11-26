
module 0x66::example_module {       
    fun foo(a: &A): &u64 {
        &a.b.c;
    }
    fun assign() {
        let s = S { f: 10 };
        let f_ref1: &u64 = &s.f; // works
        let s_ref: &S = &s;
        let f_ref2: &u64 = &s_ref.f; // also works
    }
    fun copy_resource_via_ref_bad(c: Coin) {
        let c_ref = &c;
        let counterfeit: Coin = *c_ref; // not allowed!
        pay(c);
        pay(counterfeit);
    }
}


