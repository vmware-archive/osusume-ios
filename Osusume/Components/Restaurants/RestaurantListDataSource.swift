class RestaurantListDataSource: NSObject {
    private(set) var restaurants: [Restaurant]
    private let photoRepo: PhotoRepo
    let maybeEmptyStateView: UIView?

    init(photoRepo: PhotoRepo, maybeEmptyStateView: UIView?) {
        self.photoRepo = photoRepo
        self.restaurants = [Restaurant]()
        self.maybeEmptyStateView = maybeEmptyStateView
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
        if let emptyStateView = maybeEmptyStateView where restaurants.count == 0 {
            tableView.backgroundView = emptyStateView
            tableView.separatorStyle = .None
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .SingleLine
        }

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
