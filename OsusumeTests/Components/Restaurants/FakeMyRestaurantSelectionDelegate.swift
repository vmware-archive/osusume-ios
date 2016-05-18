@testable import Osusume

class FakeMyRestaurantSelectionDelegate: MyRestaurantSelectionDelegate {
    var myRestaurantSelected_arg = RestaurantFixtures.newRestaurant(id: -1)
    func myRestaurantSelected(myRestaurant: Restaurant) {
        myRestaurantSelected_arg = myRestaurant
    }
}
