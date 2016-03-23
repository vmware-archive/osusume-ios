struct DefaultTextSearch: TextSearch {
    func search(searchTerm: String, collection: [Cuisine]) -> [Cuisine] {
        guard searchTerm != "" else {
            return collection
        }

        return collection.filter { cuisine in
            return cuisine.name.lowercaseString
                .containsString(searchTerm.lowercaseString)
        }
    }
}