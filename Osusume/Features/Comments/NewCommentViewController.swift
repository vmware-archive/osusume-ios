import UIKit

class NewCommentViewController: UIViewController {

    unowned let router : Router
    let commentRepo: CommentRepo

    let commentLabel: UILabel
    let commentTextField: UITextView

    private var constraintsNeedUpdate = true

    init(router: Router, commentRepo: CommentRepo)
    {
        self.router = router
        self.commentRepo = commentRepo

        self.commentLabel = UILabel.newAutoLayoutView()
        self.commentTextField = UITextView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Controller Lifecycle

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.cyanColor()

        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                title: "Save",
                style: .Plain,
                target: self,
                action: Selector("didTapSaveButton:")
        )

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

    //MARK: - Actions
    func didTapSaveButton(sender: UIBarButtonItem) {
        commentRepo
            .persist(NewComment(text: commentTextField.text))
            .onSuccess { [unowned self] _ in
                self.router.dismissNewCommentScreen(false)
            }
    }

}
