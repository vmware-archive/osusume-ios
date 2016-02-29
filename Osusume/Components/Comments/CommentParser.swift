import Foundation
import Result

struct CommentParser: DataParser {
    typealias ParsedObject = PersistedComment

    func parse(json: [String: AnyObject]) -> Result<PersistedComment, ParseError> {
        guard
            let id = json["id"] as? Int,
            let text = json["content"] as? String,
            let createdDateString = json["created_at"] as? String,
            let createdDate = DateConverter().formattedDateFromString(createdDateString),
            let restaurantId = json["restaurant_id"] as? Int,
            let userJson = json["user"] as? [String: String],
            let userName = userJson["name"] else
        {
            return Result.Failure(.CommentParseError)
        }

        let persistedComment = PersistedComment(
            id: id,
            text: text,
            createdDate: createdDate,
            restaurantId: restaurantId,
            userName: userName
        )

        return Result.Success(persistedComment)
    }
}
