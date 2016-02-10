import Foundation

class RestaurantConverter {

    func perform(json: [HttpJson]) -> [Restaurant] {
        let restaurantArray: [Restaurant] = json.map { restaurant in
            perform(restaurant)
        }
        return restaurantArray
    }

    func perform(json: HttpJson) -> Restaurant {
        var userName : String = ""
        if let user = json["user"] {
            userName = valueOrEmptyString(user["name"])
        }

        return Restaurant(
            id: json["id"] as! Int,
            name: json["name"] as! String,
            address: valueOrEmptyString(json["address"]),
            cuisineType: valueOrEmptyString(json["cuisine_type"]),
            offersEnglishMenu: valueOrFalse(json["offers_english_menu"]),
            walkInsOk: valueOrFalse(json["walk_ins_ok"]),
            acceptsCreditCards: valueOrFalse(json["accepts_credit_cards"]),
            notes: valueOrEmptyString(json["notes"]),
            author: userName,
            createdAt: dateOrNil(json["created_at"]),
            photoUrl: optionalURL(json["photo_url"])
        )
    }

    func valueOrEmptyString(attribute: AnyObject?) -> String {
        if let string = attribute as? String {
            return string
        } else {
            return ""
        }
    }

    func valueOrFalse(attribute: AnyObject?) -> Bool {
        if let bool = attribute as? Bool {
            return bool
        } else {
            return false
        }
    }

    func dateOrNil(attribute: AnyObject?) -> NSDate? {
        if let date = attribute as? Double {
            return NSDate(timeIntervalSince1970: date)
        } else {
            return nil
        }
    }

    func optionalURL(string: AnyObject?) -> NSURL? {
        guard let urlString = string as? String else { return nil }
        return NSURL(string: urlString)
    }
}
