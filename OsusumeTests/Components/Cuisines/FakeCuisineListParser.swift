@testable import Osusume
import Result

class FakeCuisineListParser: DataListParser {
    typealias ParsedObject = [Cuisine]

    var parse_arg: [[String : AnyObject]]!
    var parse_returnValue = Result<[Cuisine], ParseError>(value: [])
    func parse(json: [[String : AnyObject]]) -> Result<[Cuisine], ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}
