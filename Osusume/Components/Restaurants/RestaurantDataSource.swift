import UIKit

class RestaurantDataSource: NSObject, UITableViewDataSource {
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
