import Foundation

class RestaurantConverter {

    func perform(json: [NSDictionary]?) -> [Restaurant] {
        if let realJsonRests = json {
            let restaurantArray: [Restaurant] = realJsonRests.map { (restaurant: NSDictionary) in
                if let name = restaurant["name"] {
                    return Restaurant(name: name as! String)
                } else {
                    return Restaurant(name: "had problem")
                }
            }
            return restaurantArray
        } else {
            return []
        }
    }
}
