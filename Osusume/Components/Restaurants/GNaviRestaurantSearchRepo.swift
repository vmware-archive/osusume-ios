import BrightFutures

struct GNaviRestaurantSearchRepo<P: DataListParser where P.ParsedObject == [SearchResultRestaurant]>: RestaurantSearchRepo {
    let http: Http
    let parser: P
    let basePath = "http://api.gnavi.co.jp/RestSearchAPI/20150630/?keyid="
    let keyId = "deb049ee1e0f97fa5d9ff3899e77ab54"
    let formatParam = "&format=json"

    func getForSearchTerm(term: String) -> Future<[SearchResultRestaurant], RepoError> {
        let path = "\(basePath)\(keyId)\(formatParam)&name=\(term)"
        return http.get(path, headers:[:])
        .flatMap { json in
            return self.parser
            .parse(json as! [[String : AnyObject]])
            .mapError {
                _ in return RepoError.GetFailed
            }
        }
    }
}