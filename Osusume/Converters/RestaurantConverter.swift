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
        if let name = json["name"], let id = json["id"] {
            return Restaurant(id: id as! Int, name: name as! String)
        } else {
            return Restaurant(id: 0, name: "had problem")
        }
    }


}
