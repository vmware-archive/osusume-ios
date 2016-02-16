import UIKit

class NewCommentViewController: UIViewController {

    let commentLabel: UILabel
    let commentTextField: UITextView

    private var constraintsNeedUpdate = true

    init() {
        self.commentLabel = UILabel.newAutoLayoutView()
        self.commentTextField = UITextView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.cyanColor()

        view.addSubview(commentLabel)
        view.addSubview(commentTextField)

        commentLabel.text = "add a comment"

        commentTextField.layer.borderWidth = 1.0
        commentTextField.layer.borderColor = UIColor.darkGrayColor().CGColor

        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if constraintsNeedUpdate {
            commentLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 100.0)
            commentLabel.autoPinEdgeToSuperviewMargin(.Left)

            commentTextField.autoPinEdge(
                .Top,
                toEdge: .Bottom,
                ofView: commentLabel,
                withOffset: 10.0
            )
            commentTextField.autoPinEdge(
                .Leading,
                toEdge: .Leading,
                ofView: commentLabel
            )
            commentTextField.autoPinEdgeToSuperviewMargin(.Right)
            commentTextField.autoSetDimension(.Height, toSize: 100.0)

            constraintsNeedUpdate = false
        }

        super.updateViewConstraints()
    }

}