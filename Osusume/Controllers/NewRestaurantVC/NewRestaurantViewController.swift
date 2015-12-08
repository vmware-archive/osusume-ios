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
        label.text = "Restaurant Name"
        return label
    }()

    let restaurantAddressTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let restaurantAddressLabel : UILabel = {
        let label = UILabel()
        label.text = "Address"
        return label
    }()

    let restaurantCuisineTypeTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let restaurantCuisineTypeLabel : UILabel = {
        let label = UILabel()
        label.text = "Cuisine Type"
        return label
    }()

    let restaurantDishNameTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
    }()

    let restaurantDishNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name of a Dish"
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
        view.addSubview(restaurantAddressTextField)
        view.addSubview(restaurantAddressLabel)
        view.addSubview(restaurantCuisineTypeTextField)
        view.addSubview(restaurantCuisineTypeLabel)
        view.addSubview(restaurantDishNameTextField)
        view.addSubview(restaurantDishNameLabel)

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
            
            restaurantAddressLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantNameTextField)
            restaurantAddressLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantNameTextField)
            restaurantAddressLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantNameTextField)

            restaurantAddressTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantAddressLabel)
            restaurantAddressTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantAddressLabel)
            restaurantAddressTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantAddressLabel)

            restaurantCuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantAddressTextField)
            restaurantCuisineTypeLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantAddressTextField)
            restaurantCuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantAddressTextField)

            restaurantCuisineTypeTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantCuisineTypeLabel)
            restaurantCuisineTypeTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantCuisineTypeLabel)
            restaurantCuisineTypeTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantCuisineTypeLabel)

            restaurantDishNameLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantCuisineTypeTextField)
            restaurantDishNameLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantCuisineTypeTextField)
            restaurantDishNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantCuisineTypeTextField)

            restaurantDishNameTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantDishNameLabel)
            restaurantDishNameTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantDishNameLabel)
            restaurantDishNameTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantDishNameLabel)

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}