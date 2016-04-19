import UIKit

class NewCommentViewController: UIViewController {
    // MARK: - Properties
    private unowned let router: Router
    private let commentRepo: CommentRepo
    private let restaurantId: Int
    private var constraintsNeedUpdate = true
    private let textFieldPlaceHolder = "Add a comment"

    // MARK: - View Elements
    let commentTextField: UITextView

    // MARK: - Initializers
    init(router: Router, commentRepo: CommentRepo, restaurantId: Int) {
        self.router = router
        self.commentRepo = commentRepo
        self.restaurantId = restaurantId

        self.commentTextField = UITextView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.cyanColor()

        self.navigationItem.title = "Add a comment"
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                title: "Save",
                style: .Plain,
                target: self,
                action: Selector("didTapSaveButton:")
        )

        view.addSubview(commentTextField)

        commentTextField.delegate = self
        commentTextField.layer.borderWidth = 1.0
        commentTextField.layer.borderColor = UIColor.darkGrayColor().CGColor
        commentTextField.text = textFieldPlaceHolder

        automaticallyAdjustsScrollViewInsets = false

        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if constraintsNeedUpdate {
            commentTextField.autoPinEdgeToSuperviewEdge(.Top, withInset: 80.0)
            commentTextField.autoPinEdgeToSuperviewMargin(.Left)
            commentTextField.autoPinEdgeToSuperviewMargin(.Right)
            commentTextField.autoSetDimension(.Height, toSize: 100.0)

            constraintsNeedUpdate = false
        }

        super.updateViewConstraints()
    }

    // MARK: - Actions
    func didTapSaveButton(sender: UIBarButtonItem) {
        commentRepo
            .persist(
                NewComment(
                    text: commentTextField.text,
                    restaurantId: restaurantId
                )
            )
            .onSuccess { [unowned self] _ in
                self.router.dismissNewCommentScreen(true)
            }
    }
}

// MARK: - UITextViewDelegate
extension NewCommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == textFieldPlaceHolder {
            textView.text = ""
        }
    }

    func textViewDidEndEditing(textView: UITextView) {
        textView.text = textFieldPlaceHolder
    }
}
