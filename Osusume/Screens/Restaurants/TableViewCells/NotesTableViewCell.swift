class NotesTableViewCell: UITableViewCell {
    // MARK: - Properties

    // MARK: - View Elements
    let notesHeaderLabel: UILabel
    let notesTextField: UITextView

    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        notesHeaderLabel = UILabel.newAutoLayoutView()
        notesTextField = UITextView.newAutoLayoutView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .None

        addSubviews()
        configureSubviews()
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(notesHeaderLabel)
        contentView.addSubview(notesTextField)
    }

    private func configureSubviews() {
        notesHeaderLabel.text = "Notes"
        notesTextField.layer.borderWidth = 1.0
        notesTextField.layer.borderColor = UIColor.darkGrayColor().CGColor
    }

    private func addConstraints() {
        notesHeaderLabel.autoPinEdgesToSuperviewEdgesWithInsets(
            UIEdgeInsetsMake(10.0, 15.0, 0.0, 15.0),
            excludingEdge: .Bottom
        )

        notesTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesHeaderLabel)
        notesTextField.autoPinEdge(.Leading, toEdge: .Leading, ofView: notesHeaderLabel)
        notesTextField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: notesHeaderLabel)
        notesTextField.autoSetDimension(.Height, toSize: 66.0)
        notesTextField.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)
    }

    func getNotesText() -> String {
        return notesTextField.text
    }
}
