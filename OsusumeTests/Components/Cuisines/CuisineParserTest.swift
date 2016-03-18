import XCTest
import Nimble
@testable import Osusume

class CuisineParserTest: XCTestCase {

    func test_parse_parsesCuisine() {
        let parser = CuisineParser()
        let json: [String: AnyObject] =
            [
                "id": 9,
                "name": "Thai"
            ]


        let parseResult = parser.parse(json)


        let actualCuisine = parseResult.value!
        expect(actualCuisine.id).to(equal(9))
        expect(actualCuisine.name).to(equal("Thai"))
    }

    func test_parse_invalidJsonCausesParseError() {
        let parser = CuisineParser()
        let json: [String: AnyObject] =
            [
                "id": "three",
                "name": "American"
            ]


        let parseResult = parser.parse(json)


        let actualError = parseResult.error
        expect(actualError).to(equal(ParseError.CuisineParseError))
    }

}
