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

    func exactSearch(searchTerm: String, collection: [Cuisine]) -> [Cuisine] {
        guard searchTerm != "" else {
            return []
        }

        return collection.filter({ cuisine in
            return cuisine.name.lowercaseString == searchTerm.lowercaseString
        })
    }
}