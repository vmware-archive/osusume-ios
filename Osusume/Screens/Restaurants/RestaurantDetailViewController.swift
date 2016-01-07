import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantDetailViewController : UIViewController {
    unowned let router: Router
    let repo: Repo
    let id: Int
    var restaurant: Restaurant? = nil

    init(router: Router, repo: Repo, id: Int) {
        self.router = router
        self.repo = repo
        self.id = id

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantDetailViewController")
    }

    let nameLabel = UILabel()

    let backgroundImage : UIImageView = {
        let bgImage = UIImage(named: "showImage")
        let imageView = UIImageView(image: bgImage)

        return imageView
    }()

    override func loadView() {
        view = UIView()
        view.addSubview(backgroundImage)
        view.addSubview(nameLabel)
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        repo.getOne(self.id)
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurant in
                self.restaurant = returnedRestaurant
                self.nameLabel.text = self.restaurant!.name
        }
    }

    var didSetupConstraints = false

    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            backgroundImage.autoCenterInSuperview()

            nameLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
            nameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
            nameLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}