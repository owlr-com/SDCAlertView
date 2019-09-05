import UIKit

@objc(SDCAlertVisualStyle)
open class AlertVisualStyle: NSObject {
    
    /// The width of the alert. A value of 1 or below is interpreted as a percentage of the width of the view
    /// controller that presents the alert.
    @objc open var width: CGFloat
    
    /// The corner radius of the alert
    @objc open var cornerRadius: CGFloat
    
    /// The minimum distance between alert elements and the alert itself
    @objc open var contentPadding = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    
    /// The minimum distance between the alert and its superview
    @objc open var margins: UIEdgeInsets
    
    /// The parallax magnitude
    @objc open var parallax = UIOffset(horizontal: 15.75, vertical: 15.75)
    
    /// The background color of the alert. The standard blur effect will be added if nil. 
    @objc open var backgroundColor: UIColor?
    
    /// The vertical spacing between elements
    @objc open var verticalElementSpacing: CGFloat = 24
    
    /// The size of an action. The specified width is treated as a minimum width. The actual width is
    /// automatically determined.
    @objc open var actionViewSize: CGSize
    
    /// The color of an action when the user is tapping it
    @objc open var actionHighlightColor = UIColor(white: 1.0, alpha: 0.0)
    
    /// The color of the separators between actions
    @objc open var actionViewSeparatorColor = UIColor(white: 0.5, alpha: 0.5)
    
    /// The thickness of the separators between actions
    @objc open var actionViewSeparatorThickness: CGFloat = 0

    /// The font used in text fields
    @objc open var textFieldFont = UIFont.systemFont(ofSize: 13)
    
    /// The height of a text field if added using the standard method call. Won't affect text fields added
    /// directly to the alert's content view.
    @objc open var textFieldHeight: CGFloat = 25
    
    /// The border color of a text field if added using the standard method call. Won't affect text fields
    /// added directly to the alert's content view.
    @objc open var textFieldBorderColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
    
    /// The inset of the text within the text field if added using the standard method call. Won't affect text
    /// fields added directly to the alert's content view.
    @objc open var textFieldMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    /// The color for a nondestructive action's text
    @objc open var normalTextColor: UIColor?
    
    /// The color for a destructive action's text
    @objc open var destructiveTextColor = UIColor.red
    
    /// The font for an alert's preferred action
    @objc open var alertPreferredFont = UIFont.boldSystemFont(ofSize: 17)
    
    /// The font for an alert's other actions
    @objc open var alertNormalFont = UIFont.systemFont(ofSize: 17)
    
    /// The font for an action sheet's preferred action
    open var actionSheetPreferredFont = UIFont.boldSystemFont(ofSize: 20)
    
    /// The font for an action sheet's other actions
    @objc open var actionSheetNormalFont = UIFont.systemFont(ofSize: 20)
    
    /// The style of the alert.
    @objc fileprivate let alertStyle: AlertControllerStyle
    
    @objc public init(alertStyle: AlertControllerStyle) {
        self.alertStyle = alertStyle
        
        switch alertStyle {
            case .alert:
                self.width = 270

                if #available(iOS 9, *) {
                    self.cornerRadius = 13
                    self.margins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                    self.actionViewSize = CGSize(width: 90, height: 54)
                } else {
                    self.cornerRadius = 7
                    self.margins = UIEdgeInsets.zero
                    self.actionViewSize = CGSize(width: 90, height: 54)
                }

            case .actionSheet:
                self.width = 1

                if #available(iOS 9, *) {
                    self.cornerRadius = 13
                    self.margins = UIEdgeInsets(top: 30, left: 10, bottom: -10, right: 10)
                    self.actionViewSize = CGSize(width: 90, height: 57)
                } else {
                    self.cornerRadius = 4
                    self.margins = UIEdgeInsets(top: 10, left: 10, bottom: -8, right: 10)
                    self.actionViewSize = CGSize(width: 90, height: 44)
                }
        }
    }

    /// The text color for a given action.
    ///
    /// - parameter action: The action that determines the text color.
    ///
    /// - returns: The text color, or nil to use the alert's `tintColor`.
    @objc open func textColor(for action: AlertAction?) -> UIColor? {
        
        var textColor : UIColor?
        
        if let style = action?.style {
            switch(style) {
            case .normal:
                textColor = self.normalTextColor
            case .preferred:
                textColor = self.preferredTextColor
            case .destructive:
                textColor = self.destructiveTextColor
            }
        }
        
        return textColor
    }
    
    /// The font for a given action.
    ///
    /// - parameter action: The action for which to return the font.
    ///
    /// - returns: The font.
    @objc open func font(for action: AlertAction?) -> UIFont {
        
        var font = self.normalFont
        
        if let style = action?.style {
            switch (style) {
            case .preferred:
                font = self.preferredFont
            case .normal:
                font = self.normalFont
            case .destructive:
                font = self.destructiveFont
            }
        }
        
        return font
    }
    
    @objc open var titleFont: UIFont = UIFont.systemFont(ofSize: 17)
    @objc open var titleTextColor: UIColor?
    
    @objc open var messageFont: UIFont = UIFont.systemFont(ofSize: 13)
    @objc open var messageTextColor: UIColor?
    
    @objc open func buttonColor(forAction action: AlertAction?) -> UIColor? {
        
        var buttonColor : UIColor?
        
        if let style = action?.style {
            switch(style) {
            case .normal:
                buttonColor = self.normalButtonColor
            case .preferred:
                buttonColor = self.preferredButtonColor
            case .destructive:
                buttonColor = self.destructiveButtonColor
            }
        }
        
        return buttonColor
    }
    
    @objc open var normalFont : UIFont = UIFont.systemFont(ofSize: 17)
//    public var normalTextColor : UIColor?
    @objc open var normalButtonColor : UIColor?
    
    @objc open var preferredFont : UIFont = UIFont.boldSystemFont(ofSize: 17)
    @objc open var preferredTextColor : UIColor?
    @objc open var preferredButtonColor : UIColor?
    
    @objc open var destructiveFont : UIFont = UIFont.systemFont(ofSize: 17)
    @objc open var destructiveButtonColor : UIColor?
}
