import Result

enum RestaurantParseError: ErrorType {
    case InvalidField
}

struct RestaurantParser {

    func parseList(json: [[String: AnyObject]]) -> Result<[Restaurant], RestaurantParseError> {
        let restaurantArray = json.flatMap { r in privateParseSingle(r) }

        return Result.Success(restaurantArray)
    }

    func parseSingle(json: [String: AnyObject]) -> Result<Restaurant, RestaurantParseError> {

        if let restaurant = privateParseSingle(json) {
            return Result.Success(restaurant)
        }

        return Result.Failure(RestaurantParseError.InvalidField)
    }

    private func privateParseSingle(json: [String: AnyObject]) -> Restaurant? {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String
            else {
                return nil
        }

        let maybeAddress = json["address"] as? String
        let address = maybeAddress ?? ""

        let maybePlaceId = json["place_id"] as? String
        let placeId = maybePlaceId ?? ""

        let maybeLatitude = json["latitude"] as? Double
        let latitude = maybeLatitude ?? 0

        let maybeLongitude = json["longitude"] as? Double
        let longitude = maybeLongitude ?? 0

        let maybeCuisineType = json["cuisine_type"] as? String
        let cuisineType = maybeCuisineType ?? ""

        let maybeCuisineJson = json["cuisine"] as? [String: AnyObject]
        let cuisineJson = maybeCuisineJson ?? [:]
        let maybeCuisine = CuisineParser().parse(cuisineJson).value
        let cuisine = maybeCuisine ?? Cuisine(id: 0, name: "Not Specified")

        let maybeNotes = json["notes"] as? String
        let notes = maybeNotes ?? ""

        let userId: Int
        let userName: String
        let userEmail: String
        if let createdByUser = json["user"] as? [String: AnyObject]
        {
            userId = createdByUser["id"] as? Int ?? 0
            userName = createdByUser["name"] as? String ?? ""
            userEmail = createdByUser["email"] as? String ?? ""
        } else {
            userId = 0
            userName = ""
            userEmail = ""
        }

        let maybeLiked = json["liked"] as? Bool
        let liked = maybeLiked ?? false

        let maybeNumberOfLikes = json["num_likes"] as? Int
        let numberOfLikes = maybeNumberOfLikes ?? 0

        let maybePriceRangeJson = json["price_range"] as? [String: AnyObject]
        let priceRangeJson = maybePriceRangeJson ?? [:]
        let maybePriceRange = PriceRangeParser().parse(priceRangeJson).value
        let priceRange = maybePriceRange ?? PriceRange(id: 0, range: "Not Specified")

        let createdDateString = json["created_at"] as? String
        let createdAt = DateConverter.formattedDateFromString(createdDateString)

        let maybePhotoUrlsJson = json["photo_urls"] as? [[String: AnyObject]]
        let photoUrls = maybePhotoUrlsJson ?? []
        let urls: [PhotoUrl] = photoUrls.flatMap { photoUrlJson in
            return PhotoUrl(
                id: photoUrlJson["id"] as? Int ?? -1,
                url: NSURL(string: photoUrlJson["url"] as? String ?? "")!
            )
        }

        let maybeCommentsJson = json["comments"] as? [[String: AnyObject]]
        let commentsJson = maybeCommentsJson ?? []
        let comments: [PersistedComment] = commentsJson.flatMap { commentJson in
            let parseResult = CommentParser().parse(commentJson)
            return parseResult.value
        }

        return Restaurant(
            id: id,
            name: name,
            address: address,
            placeId: placeId,
            latitude: latitude,
            longitude: longitude,
            cuisineType: cuisineType,
            cuisine: cuisine,
            notes: notes,
            liked: liked,
            numberOfLikes: numberOfLikes,
            priceRange: priceRange,
            createdAt: createdAt,
            photoUrls: urls,
            createdByUser: (id: userId, name: userName, email: userEmail),
            comments: comments
        )
    }
}
