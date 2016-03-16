import UIKit

class RestaurantDataSource: NSObject, UITableViewDataSource {
    let photoRepo: PhotoRepo
    var restaurants: [Restaurant]
    let cellIdentifier = "RestaurantListItemCell"

    init(photoRepo: PhotoRepo) {
        self.photoRepo = photoRepo
        self.restaurants = [Restaurant]()
    }

    func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int
    {
        return restaurants.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell
    {
        if
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
                as? RestaurantTableViewCell
        {
            let presenter = RestaurantDetailPresenter(
                restaurant: restaurants[indexPath.row]
            )

            cell.photoImageView.image = UIImage(named: "TableCellPlaceholder")
            photoRepo.loadImageFromUrl(presenter.photoUrl)
                .onSuccess { image in
                    cell.photoImageView.image = image
            }

            cell.nameLabel.text = presenter.name
            cell.cuisineTypeLabel.text = presenter.cuisineType
            cell.authorLabel.text = presenter.author
            cell.createdAtLabel.text = presenter.creationDate

            return cell
        }

        return UITableViewCell()
    }

}
