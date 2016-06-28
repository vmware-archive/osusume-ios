struct PriceRange {
    let id: Int
    let range: String
}

extension PriceRange: Equatable {}

func ==(lhs: PriceRange, rhs: PriceRange) -> Bool {
    return lhs.id == rhs.id &&
        lhs.range == rhs.range
}
