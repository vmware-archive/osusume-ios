class ImageViewController: UIViewController {
    // MARK: - Properties
    let url: NSURL?

    // MARK: - View Elements
    let imageView: UIImageView

    // MARK: - Initializers
    init(url: NSURL) {
        self.url = url

        imageView = UIImageView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Photo"

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()

        imageView.sd_setImageWithURL(url)
    }

    // MARK: - View Setup
    private func configureNavigationBar() {}

    private func addSubviews() {
        view.addSubview(imageView)
    }

    private func configureSubviews() {}

    private func addConstraints() {
        imageView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
}
