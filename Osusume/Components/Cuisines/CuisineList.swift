struct CuisineList {
    let cuisines: [Cuisine]
}

extension CuisineList: Equatable {}

func ==(lhs: CuisineList, rhs: CuisineList) -> Bool {
    return lhs.cuisines == rhs.cuisines
}
