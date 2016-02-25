import Foundation

struct RestaurantParser {

    func parseList(json: [[String: AnyObject]]) -> [Restaurant] {
        let restaurantArray: [Restaurant] = json.map { restaurant in
            parseSingle(restaurant)
        }

        return restaurantArray
    }

    func parseSingle(json: [String: AnyObject]) -> Restaurant {
        var userName : String = ""
        if let user = json["user"] {
            userName = user["name"] as? String ?? ""
        }

        return Restaurant(
            id: json["id"] as! Int,
            name: json["name"] as! String,
            address: json["address"] as? String ?? "",
            cuisineType: json["cuisine_type"] as? String ?? "",
            offersEnglishMenu: json["offers_english_menu"] as? Bool ?? false,
            walkInsOk: json["walk_ins_ok"] as? Bool ?? false,
            acceptsCreditCards: json["accepts_credit_cards"] as? Bool ?? false,
            notes: json["notes"] as? String ?? "",
            author: userName,
            createdAt: dateOrNil(json["created_at"]),
            photoUrls: photoUrlsJsonToNSURLArray(json["photo_urls"]),
            comments: [PersistedComment(id: 1, text: "comment", restaurantId: 9)]
        )
    }

    private func dateOrNil(attribute: AnyObject?) -> NSDate? {
        if let date = attribute as? Double {
            return NSDate(timeIntervalSince1970: date)
        } else {
            return nil
        }
    }

    private func photoUrlsJsonToNSURLArray(json: AnyObject?) -> [NSURL] {
        var urls: [NSURL] = []

        if let photoUrls = json as? [[String: AnyObject]] {

            urls = photoUrls.flatMap { photoUrl in
                return urlOrNil(photoUrl)
            }

        }

        return urls
    }

    private func urlOrNil(photoUrlFromServer: AnyObject) -> NSURL? {
        if let urlAsString = photoUrlFromServer["url"] as? String {
            return NSURL(string: urlAsString)
        }
        return nil
    }
}
