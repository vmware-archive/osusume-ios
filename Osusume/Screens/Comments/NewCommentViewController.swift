import UIKit

class NewCommentViewController: UIViewController {
    // MARK: - Properties
    private unowned let router: Router
    private let commentRepo: CommentRepo
    private let restaurantId: Int

    // MARK: - Constants
    private static let kTextFieldPlaceHolder = "Add a comment"

    // MARK: - View Elements
    let commentTextView: UITextView

    // MARK: - Initializers
    init(router: Router, commentRepo: CommentRepo, restaurantId: Int) {
        self.router = router
        self.commentRepo = commentRepo
        self.restaurantId = restaurantId

        commentTextView = UITextView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.cyanColor()

        navigationItem.title = "Add a comment"
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                title: "Save",
                style: .Plain,
                target: self,
                action: Selector("didTapSaveButton:")
        )

        automaticallyAdjustsScrollViewInsets = false

        configureSubviews()
        addSubviews()
        addConstraints()
    }

    // MARK: - View Setup
    private func configureSubviews() {
        commentTextView.delegate = self
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.borderColor = UIColor.darkGrayColor().CGColor
        commentTextView.text = NewCommentViewController.kTextFieldPlaceHolder
    }

    private func addSubviews() {
        view.addSubview(commentTextView)
    }

    private func addConstraints() {
        commentTextView.autoPinEdgeToSuperviewEdge(.Top, withInset: 80.0)
        commentTextView.autoPinEdgeToSuperviewMargin(.Left)
        commentTextView.autoPinEdgeToSuperviewMargin(.Right)
        commentTextView.autoSetDimension(.Height, toSize: 100.0)
    }

    // MARK: - Actions
    @objc private func didTapSaveButton(sender: UIBarButtonItem) {
        commentRepo
            .persist(
                NewComment(
                    text: commentTextView.text,
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
        if textView.text == NewCommentViewController.kTextFieldPlaceHolder {
            textView.text = ""
        }
    }

    func textViewDidEndEditing(textView: UITextView) {
        textView.text = NewCommentViewController.kTextFieldPlaceHolder
    }
}
