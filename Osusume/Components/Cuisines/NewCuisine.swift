struct NewCuisine {
    let name: String
}

extension NewCuisine: Equatable {}

func ==(lhs: NewCuisine, rhs: NewCuisine) -> Bool {
    return lhs.name == rhs.name
}