
module 0x1234::example {
    struct Country {
        id: u8,
        population: u64
    }
    public fun new_country(c_id: u8, c_population: u64): Country {     // Country is a return type of this function!
        let country = Country {
            id: c_id,
            population: c_population
        };
        country
    }
    public fun new_country(id: u8, population: u64): Country {
        Country { id, population }
    }
    public fun get_country_population(country: Country): u64 {
        country.population // <struct>.<property>
    }
}
