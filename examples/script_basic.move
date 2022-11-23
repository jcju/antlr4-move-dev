
script {
    // Import the Debug module published at the named account address std.
    use std::debug;

    const ONE: u64 = 1;

    fun main(x: u64) {
        let sum = x + ONE;
        debug::print(&sum);
        my_addr::m::foo(@my_addr);
    }
}