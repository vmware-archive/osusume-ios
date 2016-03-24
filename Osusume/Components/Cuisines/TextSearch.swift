protocol TextSearch {
    func search(searchTerm: String, collection: [Cuisine]) -> [Cuisine]
    func exactSearch(searchTerm: String, collection: [Cuisine]) -> [Cuisine]
}