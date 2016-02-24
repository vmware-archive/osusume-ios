import Foundation
import Result

protocol DataParser {
    typealias ParsedObject
    typealias ParseError: ErrorType

    func parse(json: [String: AnyObject]) -> Result<ParsedObject, ParseError>
}
