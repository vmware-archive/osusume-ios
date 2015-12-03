import Foundation
import UIKit
import PureLayout

class NewRestaurantViewController : UIViewController {
    let restaurantNameTextField : UITextField = {
        let textField = UITextField.newAutoLayoutView()
        textField.borderStyle = .Line
        return textField
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
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            backgroundImage.autoCenterInSuperview()
            
            restaurantNameTextField.autoPinEdgeToSuperviewEdge(.Top, withInset: 30.0)
            restaurantNameTextField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
            restaurantNameTextField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
            restaurantNameTextField.autoSetDimension(.Height, toSize: 44.0)
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}