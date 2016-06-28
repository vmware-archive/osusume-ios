@testable import Osusume
import Result

class FakePriceRangeListParser: DataListParser {
    typealias ParsedObject = [PriceRange]

    var parse_arg: AnyObject!
    var parse_returnValue = Result<[PriceRange], ParseError>(value: [])
    func parse(json: AnyObject) -> Result<[PriceRange], ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}
