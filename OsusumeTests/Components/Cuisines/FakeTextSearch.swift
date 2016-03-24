@testable import Osusume

class FakeTextSearch: TextSearch {
    var search_wasCalled = false
    var search_args = (searchTerm: "", collection: [Cuisine]())
    var search_returnValue = [Cuisine]()
    func search(searchTerm: String, collection: [Cuisine]) -> [Cuisine] {
        search_wasCalled = true
        search_args = (searchTerm: searchTerm, collection: collection)
        return search_returnValue
    }

    var exactSearch_wasCalled = false
    var exactSearch_args = (searchTerm: "", collection: [Cuisine]())
    var exactSearch_returnValue = [Cuisine]()
    func exactSearch(searchTerm: String, collection: [Cuisine]) -> [Cuisine] {
        exactSearch_args = (searchTerm: searchTerm, collection: collection)
        exactSearch_wasCalled = true
        return exactSearch_returnValue
    }
}