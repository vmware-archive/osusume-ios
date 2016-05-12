import Result

protocol DataParser {
    associatedtype ParsedObject
    associatedtype ParseError: ErrorType

    func parse(json: [String: AnyObject]) -> Result<ParsedObject, ParseError>
}
