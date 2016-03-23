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
}