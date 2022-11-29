#[test_only]
script {
    use 0x1234::Debug;
    #[test(aptos_framework = @aptos_framework, token_bridge=@token_bridge, deployer=@deployer)]
    #[expected_failure(abort_code = 0)]
    fun main() {
        let bool_box = Storage::create_box<bool>(true);
        let bool_val = Storage::value(&bool_box);
        assert(bool_val, 0);
        let u64_box = Storage::create_box<u64>(1000000);
        let _ = Storage::value(&u64_box);
        Debug::print<u64>(&value);
    }
}
