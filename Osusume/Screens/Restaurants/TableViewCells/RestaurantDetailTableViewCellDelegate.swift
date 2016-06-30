@objc protocol RestaurantDetailTableViewCellDelegate: NSObjectProtocol {
    func displayAddCommentScreen(sender: UIButton)
    func didTapLikeButton(sender: UIButton)
    func displayMapScreen(sender: UIButton)
    func displayImageScreen(url: NSURL)
}
