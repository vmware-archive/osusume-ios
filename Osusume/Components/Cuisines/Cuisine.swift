struct Cuisine {
    let id: Int
    let name: String
}

extension Cuisine: Equatable {}

func ==(lhs: Cuisine, rhs: Cuisine) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name
}
