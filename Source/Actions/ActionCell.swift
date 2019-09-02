import UIKit

final class ActionCell: UICollectionViewCell {

    @IBOutlet fileprivate(set) weak var button: UIButton!
    
    var isEnabled = true {
        didSet { self.button.isEnabled = self.isEnabled }
    }

    override var isHighlighted: Bool {
        didSet { self.button.isHighlighted = self.isHighlighted }
    }

    func set(_ action: AlertAction, with visualStyle: AlertVisualStyle) {
        action.actionView = self

        self.button.titleLabel!.font = visualStyle.font(for: action)
        self.button.titleLabel!.textColor = visualStyle.textColor(for: action)

        self.button.backgroundColor = visualStyle.buttonColor(forAction: action)
        
        self.button.setAttributedTitle(action.attributedTitle, for: .normal)

        self.accessibilityLabel = action.attributedTitle?.string
        self.accessibilityTraits = UIAccessibilityTraits.button
        self.isAccessibilityElement = true
    }
}

final class ActionSeparatorView: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        if let attributes = layoutAttributes as? ActionsCollectionViewLayoutAttributes {
            self.backgroundColor = attributes.backgroundColor
        }
    }
}
