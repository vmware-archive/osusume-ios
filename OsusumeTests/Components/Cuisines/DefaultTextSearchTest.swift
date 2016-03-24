import Nimble
import XCTest
@testable import Osusume

class DefaultTextSearchTest: XCTestCase {
    let textSearch = DefaultTextSearch()
    let japaneseCuisine = Cuisine(id: 1, name: "Japanese")
    let chineseCuisine = Cuisine(id: 2, name: "Chinese")

    func test_search() {
        let filteredCuisines = textSearch.search(
            "Japanese",
            collection: [japaneseCuisine, chineseCuisine]
        )


        expect(filteredCuisines).to(equal([japaneseCuisine]))
    }

    func test_search_returnsAllForEmptyString() {
        let filteredCuisines = textSearch.search(
            "",
            collection: [japaneseCuisine]
        )


        expect(filteredCuisines).to(equal([japaneseCuisine]))
    }

    func test_search_ignoresCase() {
        let filteredCuisines = textSearch.search(
            "JAPANESE",
            collection: [japaneseCuisine]
        )


        expect(filteredCuisines).to(equal([japaneseCuisine]))
    }

    func test_search_matchesSubstrings() {
        let filteredCuisines = textSearch.search(
            "Ja",
            collection: [japaneseCuisine]
        )


        expect(filteredCuisines).to(equal([japaneseCuisine]))
    }

    func test_exactSearch() {
        let filteredCuisines = textSearch.exactSearch(
            "Japanese",
            collection: [japaneseCuisine, chineseCuisine]
        )


        expect(filteredCuisines).to(equal([japaneseCuisine]))
    }

    func test_exactSearch_returnsNoneForEmptyString() {
        let filteredCuisines = textSearch.exactSearch(
            "",
            collection: [japaneseCuisine]
        )


        expect(filteredCuisines).to(equal([]))
    }

    func test_exactSearch_ignoresCase() {
        let filteredCuisines = textSearch.exactSearch(
            "JAPANESE",
            collection: [japaneseCuisine]
        )


        expect(filteredCuisines).to(equal([japaneseCuisine]))
    }

    func test_exactSearch_doesntMatchSubstrings() {
        let filteredCuisines = textSearch.exactSearch(
            "Ja",
            collection: [japaneseCuisine]
        )

        expect(filteredCuisines).to(equal([]))
    }
}
