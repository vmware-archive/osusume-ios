import Foundation
import UIKit
import PureLayout

class NewRestaurantViewController : UIViewController {
    let restaurantNameTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let restaurantNameLabel : UILabel = {
        let label = UILabel()
        label.text = "restaurant name"
        return label
    }()

    let backgroundImage : UIImageView = {
        let bgImage = UIImage(named: "Jeana")
        let imageView = UIImageView(image: bgImage)
        
        return imageView
    }()
    
    var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        
        view.addSubview(backgroundImage)
        view.addSubview(restaurantNameTextField)
        view.addSubview(restaurantNameLabel)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            backgroundImage.autoCenterInSuperview()
            
            restaurantNameLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
            restaurantNameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
            restaurantNameLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)

            restaurantNameTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantNameLabel)
            restaurantNameTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantNameLabel)
            restaurantNameTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantNameLabel)
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}