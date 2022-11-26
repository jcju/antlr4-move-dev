
address 0x1234 {
    module m {
        struct A<T> {}

        // Finitely many types -- allowed.
        // foo<T> -> foo<T> -> foo<T> -> ... is valid
        fun foo<T>() {
            foo<T>();
        }

        // Finitely many types -- allowed.
        // foo<T> -> foo<A<u64>> -> foo<A<u64>> -> ... is valid
        fun foo<T>() {
            foo<A<u64>>();
        }
    }
}

