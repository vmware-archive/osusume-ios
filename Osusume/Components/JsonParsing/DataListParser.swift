import Result

protocol DataListParser {
    associatedtype ParsedObject

    func parse(json: [[String: AnyObject]]) -> Result<ParsedObject, ParseError>
}
