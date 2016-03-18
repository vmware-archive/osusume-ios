class Cuisine {
    let id: Int
    let name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension Cuisine: Equatable {}

func ==(lhs: Cuisine, rhs: Cuisine) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name
}
