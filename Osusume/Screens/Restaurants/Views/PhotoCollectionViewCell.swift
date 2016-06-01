class PhotoCollectionViewCell: UICollectionViewCell {
    let deleteButton: UIButton
    private var url: NSURL?
    private var isEditMode: Bool
    private var deletePhotoClosure: ((url: NSURL) -> Void)?

    override init(frame: CGRect) {
        deleteButton = UIButton()
        isEditMode = false
        deletePhotoClosure = { _ in }
        super.init(frame: frame)

        addSubviews()
        configureSubviews()
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Setup
    private func addSubviews() {
        self.addSubview(deleteButton)
    }

    private func configureSubviews() {
        self.deleteButton.backgroundColor = UIColor.redColor()
    }

    private func addConstraints() {
        deleteButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        deleteButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        deleteButton.autoSetDimension(.Height, toSize: 40)
        deleteButton.autoSetDimension(.Width, toSize: 40)
    }

    // MARK: Public Methods
    func configureCell(url: NSURL,
                       isEditMode: Bool,
                       deletePhotoClosure: ((url: NSURL) -> Void)?
    ) {
        self.url = url
        self.isEditMode = isEditMode
        self.deletePhotoClosure = deletePhotoClosure

        let imageView = UIImageView()
        imageView.sd_setImageWithURL(url)
        backgroundView = imageView

        deleteButton.hidden = !isEditMode
        deleteButton.addTarget(
            self,
            action: #selector(PhotoCollectionViewCell.deletePhoto),
            forControlEvents: .TouchUpInside
        )
    }

    // MARK: - Actions
    @objc private func deletePhoto() {
        self.deletePhotoClosure?(url: url!)
    }
}
