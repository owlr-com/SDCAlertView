class AlertView: AlertControllerView {

    var actionLayout: ActionLayout = .automatic
    var textFieldsViewController: TextFieldsViewController? {
        didSet { self.textFieldsViewController?.visualStyle = self.visualStyle }
    }

    var topView: UIView { return self.scrollView }

    override var actionTappedHandler: ((AlertAction) -> Void)? {
        get { return self.actionsCollectionView.actionTapped }
        set { self.actionsCollectionView.actionTapped = newValue }
    }

    override var visualStyle: AlertVisualStyle! {
        didSet {
            self.textFieldsViewController?.visualStyle = self.visualStyle
            self.updateLabelAppearance()
        }
    }

    fileprivate let scrollView = UIScrollView()

    fileprivate var elements: [UIView] {
        let possibleElements: [UIView?] = [
            self.titleLabel,
            self.messageLabel,
            (self.tertiaryTitle != nil) ? self.tertiaryButton : nil,
            self.textFieldsViewController?.view,
            self.contentView.subviews.count > 0 ? self.contentView : nil,
        ]

        return possibleElements.compactMap { $0 }
    }

    fileprivate var contentHeight: CGFloat {
        guard let lastElement = self.elements.last else {
            return 0
        }

        lastElement.layoutIfNeeded()
        return lastElement.frame.maxY + self.visualStyle.contentPadding.bottom
    }

    convenience init() {
        self.init(frame: .zero)
        self.updateLabelAppearance()
    }
    
    func updateLabelAppearance() {
        if let visualStyle = self.visualStyle {
            self.titleLabel.font = visualStyle.titleFont
            self.titleLabel.textColor = visualStyle.titleTextColor
            self.messageLabel.font = visualStyle.messageFont
            self.messageLabel.textColor = visualStyle.messageTextColor
            self.tertiaryButton.titleLabel!.font = visualStyle.messageFont
            self.tertiaryButton.titleLabel!.textColor = visualStyle.messageTextColor
            self.tertiaryButton.backgroundColor = visualStyle.tertiaryButtonBackgroundColor
        }
    }

    override func prepareLayout() {
        super.prepareLayout()

        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.scrollView)

        self.updateCollectionViewScrollDirection()

        self.createBackground()
        self.createUI()
        self.createContentConstraints()
        self.updateUI()
    }

    // MARK: - Private methods

    fileprivate func createBackground() {
        if let color = self.visualStyle.backgroundColor {
            self.backgroundColor = color
        } else {
            let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
            backgroundView.translatesAutoresizingMaskIntoConstraints = false

            self.insertSubview(backgroundView, belowSubview: self.scrollView)
            backgroundView.sdc_alignEdges(.all, with: self)
        }
    }

    fileprivate func createUI() {
        for element in self.elements {
            element.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(element)
        }

        self.actionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.actionsCollectionView)
    }

    fileprivate func updateCollectionViewScrollDirection() {
        guard let layout = self.actionsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else
        {
            return
        }

        if self.actionLayout == .horizontal || (self.actions.count == 2 && self.actionLayout == .automatic) {
            layout.scrollDirection = .horizontal
        } else {
            layout.scrollDirection = .vertical
        }
    }

    fileprivate func updateUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.visualStyle.cornerRadius
        self.textFieldsViewController?.visualStyle = self.visualStyle
    }

    override var intrinsicContentSize: CGSize {
        let totalHeight = self.contentHeight + self.actionsCollectionView.displayHeight
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    // MARK: - Constraints

    fileprivate func createContentConstraints() {
        if self.elements.contains(self.contentView) {
            self.createCustomContentViewConstraints()
            self.createTitleLabelConstraints()
        } else {
            self.createTitleAtTopLabelConstraints()
        }
        
        if let _ = self.tertiaryTitle {
            self.createTertiaryButtonConstraints()
        }
        
        self.createMessageLabelConstraints()
        self.createTextFieldsConstraints()
        self.createCollectionViewConstraints()
        self.createScrollViewConstraints()
    }

    fileprivate func createCustomContentViewConstraints() {

        let contentPadding = self.visualStyle.contentPadding
        self.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .top,
            relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: contentPadding.top))
        let insets = UIEdgeInsets(top: 0, left: contentPadding.left, bottom: 0, right: -contentPadding.right)
        self.contentView.sdc_alignEdges([.left, .right], with: self, insets: insets)
        
        self.pinBottomOfScrollView(to: self.contentView, withPriority: UILayoutPriority.defaultLow)
    }
    
    fileprivate func createTitleLabelConstraints() {
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .firstBaseline,
            relatedBy: .equal, toItem: self.contentView, attribute: .lastBaseline , multiplier: 1,
            constant: self.visualStyle.verticalElementSpacing))
        let contentPadding = self.visualStyle.contentPadding
        let insets = UIEdgeInsets(top: 0, left: contentPadding.left, bottom: 0, right: -contentPadding.right)
        self.titleLabel.sdc_alignEdges([.left, .right], with: self, insets: insets)
        
        self.pinBottomOfScrollView(to: self.titleLabel, withPriority: UILayoutPriority.defaultLow + 1)
    }
    
    fileprivate func createTitleAtTopLabelConstraints() {
        let contentPadding = self.visualStyle.contentPadding
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .top,
            relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: contentPadding.top))
        let insets = UIEdgeInsets(top: 0, left: contentPadding.left, bottom: 0, right: -contentPadding.right)
        self.titleLabel.sdc_alignEdges([.left, .right], with: self, insets: insets)

        self.pinBottomOfScrollView(to: self.titleLabel, withPriority: UILayoutPriority.defaultLow)
    }

    fileprivate func createMessageLabelConstraints() {
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel, attribute: .firstBaseline,
            relatedBy: .equal, toItem: self.titleLabel, attribute: .lastBaseline , multiplier: 1,
            constant: self.visualStyle.verticalElementSpacing))
        let contentPadding = self.visualStyle.contentPadding
        let insets = UIEdgeInsets(top: 0, left: contentPadding.left, bottom: 0, right: -contentPadding.right)
        self.messageLabel.sdc_alignEdges([.left, .right], with: self, insets: insets)

        self.pinBottomOfScrollView(to: self.messageLabel, withPriority: UILayoutPriority.defaultLow + 1)
    }
    
    fileprivate func createTertiaryButtonConstraints() {
        self.addConstraint(NSLayoutConstraint(item: self.tertiaryButton, attribute: .top,
            relatedBy: .equal, toItem: self.messageLabel, attribute: .bottom , multiplier: 1,
            constant: 0))
        let contentPadding = self.visualStyle.contentPadding
        let insets = UIEdgeInsets(top: 0, left: contentPadding.left, bottom: 0, right: -contentPadding.right)
        self.tertiaryButton.sdc_alignEdges([.left, .right], with: self, insets: insets)

        self.pinBottomOfScrollView(to: self.tertiaryButton, withPriority: UILayoutPriority.defaultLow + 2)
    }

    fileprivate func createTextFieldsConstraints() {
        guard let textFieldsView = self.textFieldsViewController?.view,
              let height = self.textFieldsViewController?.requiredHeight else
        {
            return
        }

        // The text fields view controller needs the visual style to calculate its height
        self.textFieldsViewController?.visualStyle = self.visualStyle

        let widthOffset = self.visualStyle.contentPadding.left + self.visualStyle.contentPadding.right

        self.addConstraint(NSLayoutConstraint(item: textFieldsView, attribute: .top, relatedBy: .equal,
            toItem: self.messageLabel, attribute: .lastBaseline, multiplier: 1,
            constant: self.visualStyle.verticalElementSpacing))

        textFieldsView.sdc_pinWidth(toWidthOf: self, offset: -widthOffset)
        textFieldsView.sdc_alignHorizontalCenter(with: self)
        textFieldsView.sdc_pinHeight(height)

        self.pinBottomOfScrollView(to: textFieldsView, withPriority: UILayoutPriority.defaultLow + 3)
    }

    fileprivate func createCollectionViewConstraints() {
        let height = self.actionsCollectionView.displayHeight
        let heightConstraint = NSLayoutConstraint(item: self.actionsCollectionView, attribute: .height,
            relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        heightConstraint.priority = UILayoutPriority.defaultHigh
        self.actionsCollectionView.addConstraint(heightConstraint)

        let contentPadding = self.visualStyle.contentPadding
        self.actionsCollectionView.sdc_alignEdges([.left, .right], with: self, insets: UIEdgeInsets(top: 0, left: contentPadding.left, bottom: 0, right: -contentPadding.right))
        
        self.actionsCollectionView.sdc_alignEdge(.top, with: .bottom, of: self.scrollView)
        self.actionsCollectionView.sdc_alignHorizontalCenter(with: self)
        self.actionsCollectionView.sdc_alignEdges(.bottom, with: self, insets: UIEdgeInsets(top: 0, left: 0, bottom: -contentPadding.bottom, right: 0))
    }

    fileprivate func createScrollViewConstraints() {
        let contentPadding = self.visualStyle.contentPadding
        self.scrollView.sdc_alignEdges([.left, .right, .top], with: self, insets: UIEdgeInsets(top: contentPadding.top, left: contentPadding.left, bottom: 0, right: -contentPadding.right))
        self.scrollView.layoutIfNeeded()

        let scrollViewHeight = self.scrollView.contentSize.height
        let constraint = NSLayoutConstraint(item: self.scrollView, attribute: .height, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: scrollViewHeight)
        constraint.priority = UILayoutPriority.defaultHigh
        self.scrollView.addConstraint(constraint)
    }

    fileprivate func pinBottomOfScrollView(to view: UIView, withPriority priority: UILayoutPriority) {
        let bottomAnchor = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
            toItem: self.scrollView, attribute: .bottom, multiplier: 1,
            constant: -self.visualStyle.contentPadding.bottom)
        bottomAnchor.priority = priority
        self.addConstraint(bottomAnchor)
    }
}
