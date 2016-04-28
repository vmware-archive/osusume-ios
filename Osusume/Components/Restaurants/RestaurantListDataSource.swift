import UIKit

class RestaurantListDataSource: NSObject {
    private(set) var restaurants: [Restaurant]
    private let photoRepo: PhotoRepo

    init(photoRepo: PhotoRepo) {
        self.photoRepo = photoRepo
        self.restaurants = [Restaurant]()
    }

    func updateRestaurants(restaurants: [Restaurant]) {
        self.restaurants = restaurants
    }
}

extension RestaurantListDataSource: UITableViewDataSource {
    func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return restaurants.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if
            let cell = tableView.dequeueReusableCellWithIdentifier(
                String(RestaurantTableViewCell)
                ) as? RestaurantTableViewCell
        {
            let presenter = RestaurantDetailPresenter(
                restaurant: restaurants[indexPath.row]
            )

            cell.configureView(photoRepo, presenter: presenter)

            return cell
        }

        return UITableViewCell()
    }
}
