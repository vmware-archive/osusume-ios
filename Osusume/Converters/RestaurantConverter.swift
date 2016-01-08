import Foundation

class RestaurantConverter {

    func perform(json: [NSDictionary]?) -> [Restaurant] {
        if let realJsonRests = json {
            let restaurantArray: [Restaurant] = realJsonRests.map { (restaurant: NSDictionary) in
                perform(restaurant)
            }
            return restaurantArray
        } else {
            return []
        }
    }

    func perform(json: NSDictionary) -> Restaurant {
        return Restaurant(
            id: json["id"] as! Int,
            name: json["name"] as! String,
            address: valueOrEmptyString(json["address"]),
            cuisineType: valueOrEmptyString(json["cuisine_type"]),
            offersEnglishMenu: valueOrFalse(json["offers_english_menu"]),
            walkInsOk: valueOrFalse(json["walk_ins_ok"]),
            acceptsCreditCards: valueOrFalse(json["accepts_credit_cards"])
        )
    }

    func valueOrEmptyString(attribute: AnyObject?) -> String {
        if !(attribute is NSNull) {
            return attribute as! String
        } else {
            return ""
        }
    }

    func valueOrFalse(attribute: AnyObject?) -> Bool {
        if !(attribute is NSNull) {
            return attribute as! Bool
        } else {
            return false
        }
    }
}
