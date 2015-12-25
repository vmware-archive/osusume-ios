import Foundation
import UIKit
import PureLayout

class RestaurantDetailViewController : UIViewController {
    unowned let router: Router
    let repo: Repo
    let id: Int
    var restaurant = Restaurant(name: "initial value")

    init(router: Router, repo: Repo, id: Int) {
        self.router = router
        self.repo = repo
        self.id = id

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantDetailViewController")
    }

    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "bob's"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        repo.getOne(self.id)
            .onSuccess { [unowned self] returnedRestaurant in
                self.restaurant = returnedRestaurant
                self.view.addSubview(self.nameLabel)
        }
    }
}