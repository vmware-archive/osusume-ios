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

    let saveTextLabel : UILabel = {
        let label = UILabel()
        label.text = "Not Saved"
        return label
    }()

    let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save", forState: .Normal)
        return button
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
        view.addSubview(saveTextLabel)
        view.addSubview(saveButton)

        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        saveButton.addTarget(self, action:Selector("saveButtonTapped:"), forControlEvents: .TouchUpInside)
    }

    // MARK: actions
    func saveButtonTapped(sender: UIButton) {
        saveTextLabel.text = "Saved"
    }

    // MARK: auto layout
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            backgroundImage.autoCenterInSuperview()
            
            restaurantNameLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
            restaurantNameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
            restaurantNameLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)

            restaurantNameTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantNameLabel)
            restaurantNameTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantNameLabel)
            restaurantNameTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantNameLabel)
            
            restaurantAddressLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantNameLabel)
            restaurantAddressLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantNameLabel)
            restaurantAddressLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantNameTextField)

            restaurantAddressTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantNameLabel)
            restaurantAddressTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantNameLabel)
            restaurantAddressTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantAddressLabel)

            restaurantCuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantNameLabel)
            restaurantCuisineTypeLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantNameLabel)
            restaurantCuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantAddressTextField)

            restaurantCuisineTypeTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantNameLabel)
            restaurantCuisineTypeTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantNameLabel)
            restaurantCuisineTypeTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantCuisineTypeLabel)

            restaurantDishNameLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantNameLabel)
            restaurantDishNameLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantNameLabel)
            restaurantDishNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantCuisineTypeTextField)

            restaurantDishNameTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: restaurantNameLabel)
            restaurantDishNameTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: restaurantNameLabel)
            restaurantDishNameTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantDishNameLabel)

            saveTextLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: restaurantDishNameTextField)
            saveTextLabel.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            saveButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: saveTextLabel)
            saveButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}