
public(friend) entry fun mint(account: signer, value: u64) {
    move_to(&account, Coin { value })
}