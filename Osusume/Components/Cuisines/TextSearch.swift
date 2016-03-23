protocol TextSearch {
    func search(searchTerm: String, collection: [Cuisine]) -> [Cuisine]
}