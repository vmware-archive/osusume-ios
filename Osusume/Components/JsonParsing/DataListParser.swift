import Result

protocol DataListParser {
    typealias ParsedObject

    func parse(json: [[String: AnyObject]]) -> Result<ParsedObject, ParseError>
}
