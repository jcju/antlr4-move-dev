script {
    fun main() {
        let z = if (x < 100) x else 100;
        let z = if (maximum < 10) 10u8 else 100u64;

        let maximum = if (x > y) x else y;
        if (maximum < 10) {
            x = x + 10;
            y = y + 10;
        } else if (x >= 10 && y >= 10) {
            x = x - 10;
            y = y - 10;
        }
        if (a == b)
            return 0;
        if (a != b) {
            return 1;
        }
    }
}
