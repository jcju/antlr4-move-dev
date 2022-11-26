
// test of function visibility parsing

module 0x1234::HelloWorld {
    public(friend) fun mint(account: signer, value: u64) {
        move_to(&account, Coin { value })
    }
}

