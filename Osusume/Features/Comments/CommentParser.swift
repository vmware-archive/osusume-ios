import Foundation
import Result

struct CommentParser: DataParser {
    typealias ParsedObject = PersistedComment

    func parse(json: HttpJson) -> Result<PersistedComment, ParseError> {

        guard
            let id = json["id"] as? Int,
            let text = json["content"] as? String,
            let restaurantId = json["restaurant_id"] as? Int else
        {
            return Result.Failure(.CommentParseError)
        }

        let persistedComment = PersistedComment(
            id: id,
            text: text,
            restaurantId: restaurantId
        )

        return Result.Success(persistedComment)
    }
}
