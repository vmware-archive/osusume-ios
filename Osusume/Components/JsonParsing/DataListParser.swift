import Result

protocol DataListParser {
    associatedtype ParsedObject

    func parse(json: AnyObject) -> Result<ParsedObject, ParseError>
}
