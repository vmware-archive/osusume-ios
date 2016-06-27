import BrightFutures

@testable import Osusume

class FakeHttp: Http {
    var get_args = (path: "", headers: [String : String]())
    var get_returnValue = Future<AnyObject, RepoError>()
    func get(
        path: String,
        headers: [String : String]
        ) -> Future<AnyObject, RepoError>
    {
        get_args = (path: path, headers: headers)

        return get_returnValue
    }

    var post_args = (
        path: "",
        headers: [String : String](),
        parameters: [String : AnyObject]()
    )
    var post_returnValue = Future<AnyObject, RepoError>()
    func post(
        path: String,
        headers: [String : String],
        parameters: [String : AnyObject]
        ) -> Future<AnyObject, RepoError>
    {
        post_args = (path: path, headers: headers, parameters: parameters)

        return post_returnValue
    }

    var patch_args = (
        path: "",
        headers: [String : String](),
        parameters: [String : AnyObject]()
    )
    var patch_returnValue = Future<[String : AnyObject], RepoError>()
    func patch(
        path: String,
        headers: [String : String],
        parameters: [String : AnyObject]
        ) -> Future<[String : AnyObject], RepoError>
    {
        patch_args = (path: path, headers: headers, parameters: parameters)

        return patch_returnValue
    }

    var delete_args = (
        path: "",
        headers: [String : String](),
        parameters: [String : AnyObject]()
    )
    var delete_returnValue = Future<[String : AnyObject], RepoError>()
    var delete_wasCalled = false
    func delete(
        path: String,
        headers: [String : String],
        parameters: [String : AnyObject]
        ) -> Future<[String : AnyObject], RepoError>
    {
        delete_wasCalled = true
        delete_args = (path: path, headers: headers, parameters: parameters)

        return delete_returnValue
    }
}

