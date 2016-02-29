class ImageViewController: UIViewController {

    let url: NSURL?
    //MARK: - View Elements
    let imageView = UIImageView()

    //MARK: - Initializers
    init(url: NSURL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        imageView.sd_setImageWithURL(url)
        view.addSubview(imageView)
        applyViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Constraints
    func applyViewConstraints() {
        imageView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
}
