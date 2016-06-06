import UIKit

final class ActionCell: UICollectionViewCell {

    @IBOutlet private(set) weak var button: UIButton!
    
    var enabled = true {
        didSet { self.button.enabled = self.enabled }
    }

    override var highlighted: Bool {
        didSet { self.button.highlighted = self.highlighted }
    }

    func setAction(action: AlertAction, withVisualStyle visualStyle: AlertVisualStyle) {
        action.actionView = self

        self.button.titleLabel!.font = visualStyle.font(forAction: action)
        self.button.titleLabel!.textColor = UIColor.whiteColor()

        self.button.backgroundColor = visualStyle.textColor(forAction: action);
        
        self.button.setAttributedTitle(action.attributedTitle, forState: .Normal)

        self.accessibilityLabel = action.attributedTitle?.string
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.isAccessibilityElement = true
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.button.backgroundColor = tintColor;
    }
}

final class ActionSeparatorView: UICollectionReusableView {

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)

        if let attributes = layoutAttributes as? ActionsCollectionViewLayoutAttributes {
            self.backgroundColor = attributes.backgroundColor
        }
    }
}
