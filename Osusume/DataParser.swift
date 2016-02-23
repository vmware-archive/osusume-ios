import Foundation
import Result

protocol DataParser {
    typealias ParsedObject
    typealias ParseError: ErrorType

    func parse(json: HttpJson) -> Result<ParsedObject, ParseError>
}
