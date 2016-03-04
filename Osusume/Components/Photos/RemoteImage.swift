import UIKit

protocol RemoteImage {
    func getImageURL() -> NSURL!
    func setImage(url: NSURL!, placeholderImage: UIImage!)
}

extension UIImageView: RemoteImage {
    func getImageURL() -> NSURL! {
        return self.sd_imageURL()
    }

    func setImage(url: NSURL!, placeholderImage: UIImage!) {
        self.sd_setImageWithURL(url, placeholderImage: placeholderImage)
    }
}
