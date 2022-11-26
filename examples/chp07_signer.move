
script {
    use std::signer;
//  fun main(s: signer) {
    fun main(s1: signer, s2: signer, x: u64, y: u8) {
        assert!(signer::address_of(&s) == @0x42, 0);
    }
}
