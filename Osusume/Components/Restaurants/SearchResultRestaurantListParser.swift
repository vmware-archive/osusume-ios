import Result

protocol SearchResultRestaurantListParser: DataListParser {
    func parse(json: [[String : AnyObject]])-> Result<[SearchResultRestaurant], ParseError>
}
