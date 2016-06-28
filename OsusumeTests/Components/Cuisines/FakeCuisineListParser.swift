@testable import Osusume
import Result

class FakeCuisineListParser: DataListParser {
    typealias ParsedObject = [Cuisine]

    var parse_arg: AnyObject!
    var parse_returnValue = Result<[Cuisine], ParseError>(value: [])
    func parse(json: AnyObject) -> Result<[Cuisine], ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}
