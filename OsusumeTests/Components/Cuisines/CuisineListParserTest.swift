import XCTest
import Nimble
import Result
@testable import Osusume

class CuisineListParserTest: XCTestCase {
    var parser: CuisineListParser!

    override func setUp() {
        parser = CuisineListParser()
    }

    func test_parse_parsesListOfCuisines() {
        let json: [[String: AnyObject]] = [
            [
                "id": 1,
                "name": "American",
            ],
            [
                "id": 2,
                "name": "Italian",
            ]
        ]


        let cuisineResult = parser.parse(json)


        let cuisineList = cuisineResult.value!
        expect(cuisineList.count).to(equal(2))
        expect(cuisineList.first?.id).to(equal(1))
        expect(cuisineList.first?.name).to(equal("American"))
        expect(cuisineList.last?.id).to(equal(2))
        expect(cuisineList.last?.name).to(equal("Italian"))
    }

    func test_parseIncompleteJson_excludesIncompleteCuisinesFromList() {
        let json: [[String: AnyObject]] = [
            [
                "id": 3,
            ],
            [
                "id": 4,
                "name": "French",
            ]
        ]


        let cuisineResult = parser.parse(json)


        let cuisineList = cuisineResult.value!
        expect(cuisineList.count).to(equal(1))
        expect(cuisineList.first?.id).to(equal(4))
        expect(cuisineList.first?.name).to(equal("French"))
    }

    func test_parseIncorrectValueType_excludesInvalidCuisinesFromList() {
        let json: [[String: AnyObject]] = [
            [
                "id": "three",
                "name": "Thai"
            ],
            [
                "id": 4,
                "name": "French",
            ]
        ]


        let cuisineResult = parser.parse(json)


        let cuisineList = cuisineResult.value!
        expect(cuisineList.count).to(equal(1))
        expect(cuisineList.first?.id).to(equal(4))
        expect(cuisineList.first?.name).to(equal("French"))
    }
}
