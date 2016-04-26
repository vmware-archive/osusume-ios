import UIKit

class RestaurantListDataSource: NSObject, UITableViewDataSource {
    var myPosts: [Restaurant]
    private let photoRepo: PhotoRepo

    init(photoRepo: PhotoRepo) {
        self.photoRepo = photoRepo
        self.myPosts = [Restaurant]()
    }

    func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int
    {
        return myPosts.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell
    {
        if
            let cell = tableView.dequeueReusableCellWithIdentifier(
                String(RestaurantTableViewCell)
            ) as? RestaurantTableViewCell
        {
            let presenter = RestaurantDetailPresenter(
                restaurant: myPosts[indexPath.row]
            )

            cell.configureView(photoRepo, presenter: presenter)

            return cell
        }

        return UITableViewCell()
    }
}
