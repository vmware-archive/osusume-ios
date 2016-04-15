import XCTest
import Nimble
@testable import Osusume

class PriceRangeListParserTest: XCTestCase {

    func test_parse_parsesListOfPriceRanges() {
        let parser = PriceRangeListParser()
        let json: [[String: AnyObject]] = [
            [
                "id": 1,
                "range": "Price Range #1",
            ],
            [
                "id": 2,
                "range": "Price Range #2",
            ]
        ]


        let priceRangeListResult = parser.parse(json)


        let priceRangeList = priceRangeListResult.value!
        expect(priceRangeList.count).to(equal(2))
        expect(priceRangeList.first?.id).to(equal(1))
        expect(priceRangeList.first?.range).to(equal("Price Range #1"))
        expect(priceRangeList.last?.id).to(equal(2))
        expect(priceRangeList.last?.range).to(equal("Price Range #2"))
    }

    func test_parse_skipsInvalidPriceRanges() {
        let parser = PriceRangeListParser()
        let json: [[String: AnyObject]] = [
            [
                "id": "one",
                "range": 1000,
            ],
            [
                "id": 2,
                "range": "Price Range #2",
            ]
        ]


        let priceRangeListResult = parser.parse(json)


        let priceRangeList = priceRangeListResult.value!
        expect(priceRangeList.count).to(equal(1))
        expect(priceRangeList.first?.id).to(equal(2))
        expect(priceRangeList.first?.range).to(equal("Price Range #2"))
    }

    func test_parse_skipsInvalidJsonObjects() {
        let parser = PriceRangeListParser()
        let json: [[String: AnyObject]] = [
            [
                "id": 1,
                "range": "Price Range #1",
            ],
            [
                "name": 2,
                "range": "Price Range #2",
            ]
        ]


        let priceRangeListResult = parser.parse(json)


        let priceRangeList = priceRangeListResult.value!
        expect(priceRangeList.count).to(equal(1))
        expect(priceRangeList.first?.id).to(equal(1))
        expect(priceRangeList.first?.range).to(equal("Price Range #1"))
    }

}
