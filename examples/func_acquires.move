
public fun extract_balance(addr address) u64 acquires Balance {
    let Balance { value } = move_from(addr);  acquires needed
    value
}