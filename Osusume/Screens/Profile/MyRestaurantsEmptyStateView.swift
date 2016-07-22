class MyRestaurantsEmptyStateView: UIView {
    // MA@objc @objc RK: - View Elements
    let callToActionLabel: UILabel
    let callToActionButton: UIButton
    let delegate: EmptyStateCallToActionDelegate

    // MARK: - Initializers
    init(delegate: EmptyStateCallToActionDelegate) {
        callToActionLabel = UILabel.newAutoLayoutView()
        callToActionButton = UIButton(type: UIButtonType.System)
        self.delegate = delegate

        super.init(frame: CGRect())

        addSubviews()
        configureSubviews()
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Setup
    private func addSubviews() {
        self.addSubview(callToActionLabel)
        self.addSubview(callToActionButton)
    }

    private func configureSubviews() {
        callToActionLabel.numberOfLines = 3
        callToActionLabel.textAlignment = .Center
        callToActionLabel.text = "No restaurant yet." +
            "\nPlease share your favorite restaurant " +
            "\nwith other pivots"

        callToActionButton.setTitle("+ add a restaurant", forState: .Normal)
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        callToActionButton.addTarget(
            self.delegate,
            action: #selector(EmptyStateCallToActionDelegate.callToActionCallback(_:)),
            forControlEvents: .TouchUpInside
        )
    }

    private func addConstraints() {
        callToActionLabel.autoAlignAxis(
            .Horizontal,
            toSameAxisOfView: self,
            withOffset: -30.0
        )
        callToActionLabel.autoAlignAxisToSuperviewAxis(.Vertical)

        callToActionButton.autoPinEdge(
            .Top,
            toEdge: .Bottom,
            ofView: callToActionLabel,
            withOffset: 15.0
        )
        callToActionButton.autoAlignAxis(
            .Vertical,
            toSameAxisOfView: callToActionLabel
        )
    }
}