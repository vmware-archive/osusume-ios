import BrightFutures

struct GNaviRestaurantSearchRepo: RestaurantSearchRepo {
    let http: Http
    let parser: SearchResultRestaurantListParser
    let basePath = "http://api.gnavi.co.jp/RestSearchAPI/20150630/?keyid="
    let keyId = "c174f342a2294ea4419083ad100a8131"
    let formatParam = "&format=json"

    func getForSearchTerm(term: String) -> Future<[SearchResultRestaurant], RepoError> {
        let encodedString = term.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let path = "\(basePath)\(keyId)\(formatParam)&name=\(encodedString!)"
        return http.get(path, headers:[:])
        .flatMap { json in
            return self.parser
            .parseGNaviResponse(json as! [String : AnyObject])
            .mapError {
                _ in return RepoError.GetFailed
            }
        }
    }
}