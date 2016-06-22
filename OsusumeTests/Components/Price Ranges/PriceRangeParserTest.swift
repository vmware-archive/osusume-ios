import XCTest
import Nimble
@testable import Osusume

class PriceRangeParserTest: XCTestCase {
    
    func test_parse_parsesPriceRange() {
        let parser = PriceRangeParser()
        let json: [String: AnyObject] = ["id": 9, "range": "100-200"]
        
        
        let parseResult = parser.parse(json)
        
        
        let actualPriceRange = parseResult.value!
        expect(actualPriceRange.id).to(equal(9))
        expect(actualPriceRange.range).to(equal("100-200"))
    }
    
    func test_parse_invalidJsonCausesParseError() {
        let parser = PriceRangeParser()
        let json: [String: AnyObject] = ["id": "three", "range": "100-200"]
        
        
        let parseResult = parser.parse(json)
        
        
        let actualError = parseResult.error
        expect(actualError).to(equal(ParseError.PriceRangeParseError))
    }
}
