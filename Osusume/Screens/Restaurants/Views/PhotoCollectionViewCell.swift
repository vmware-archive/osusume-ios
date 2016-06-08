class PhotoCollectionViewCell: UICollectionViewCell {
    let deleteButton: UIButton
    private var photoUrl: PhotoUrl?
    private var isEditMode: Bool
    private var deletePhotoClosure: ((photoUrlId: Int) -> Void)?

    override init(frame: CGRect) {
        deleteButton = UIButton(type: .System)
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
        let font = UIFont(name: "Avenir-Heavy", size: 26.0)
        let attributedTitle = NSAttributedString(
            string: "X",
            attributes: [
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : font!
            ]
        )
        self.deleteButton.setAttributedTitle(attributedTitle, forState: .Normal)
        self.deleteButton.backgroundColor = UIColor.redColor()
    }

    private func addConstraints() {
        deleteButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        deleteButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        deleteButton.autoSetDimension(.Height, toSize: 40)
        deleteButton.autoSetDimension(.Width, toSize: 40)
    }

    // MARK: Public Methods
    func configureCell(photoUrl: PhotoUrl,
                       isEditMode: Bool,
                       deletePhotoClosure: ((photoUrlId: Int) -> Void)?
    ) {
        self.photoUrl = photoUrl
        self.isEditMode = isEditMode
        self.deletePhotoClosure = deletePhotoClosure

        let imageView = UIImageView()
        imageView.sd_setImageWithURL(photoUrl.url)
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
        self.deletePhotoClosure?(photoUrlId: (photoUrl?.id)!)
    }
}
