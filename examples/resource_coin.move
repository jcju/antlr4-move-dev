address 0x123456 {
    module exampleCoin {
        // We do not want the Coin to be copied because that would be duplicating this "money",
        // so we do not give the struct the 'copy' ability.
        // Similarly, we do not want programmers to destroy coins, so we do not give the struct the
        // 'drop' ability.
        // However, we *want* users of the modules to be able to store this coin in persistent global
        // storage, so we grant the struct the 'store' ability. This struct will only be inside of
        // other resources inside of global storage, so we do not give the struct the 'key' ability.
        struct Coin has store {
            value: u64,
        }
        public fun mint(value: u64): Coin {
            // You would want to gate this function with some form of access control to prevent anyone using this module from minting an infinite amount of coins
            Coin { value }
        }
        public fun withdraw(coin: &mut Coin, amount: u64): Coin {
            assert!(coin.balance >= amount, 1000);
            coin.value = coin.value - amount;
            Coin { value: amount }
        }
        public fun deposit(coin: &mut Coin, other: Coin) {
            let Coin { value } = other;
            coin.value = coin.value + value;
        }
        public fun split(coin: Coin, amount: u64): (Coin, Coin) {
            let other = withdraw(&mut coin, amount);
            (coin, other)
        }
        public fun merge(coin1: Coin, coin2: Coin): Coin {
            deposit(&mut coin1, coin2);
            coin1
        }
        public fun destroy_zero(coin: Coin) {
            let Coin { value } = coin;
            assert!(value == 0, 1001);
        }
    }
}
