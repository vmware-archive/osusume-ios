import Result

extension NSURLRequest {
    func responseJSON(responseHandler: (Result<AnyObject, RepoError>) -> Void) {

        let completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void = { maybeData, maybeResponse, maybeError in

            guard
                maybeError == nil,
                let response = maybeResponse as? NSHTTPURLResponse where response.statusCode < 400,
                let data = maybeData else
            {
                responseHandler(.Failure(RepoError.GetFailed))
                return
            }

            guard
                let json = try? NSJSONSerialization.JSONObjectWithData(
                    data,
                    options: []
                ) else
            {
                responseHandler(.Failure(RepoError.GetFailed))
                return
            }

            responseHandler(.Success(json))
        }

        NSURLSession.sharedSession()
            .dataTaskWithRequest(self, completionHandler: completionHandler)
            .resume()
    }
}
