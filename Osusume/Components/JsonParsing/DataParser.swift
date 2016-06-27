import Result

protocol DataParser {
    associatedtype ParsedObject
    associatedtype ParseError: ErrorType

    func parse(json: AnyObject) -> Result<ParsedObject, ParseError>
}
