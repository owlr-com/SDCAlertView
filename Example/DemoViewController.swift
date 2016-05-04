import UIKit
import SDCAlertView

final class DemoViewController: UITableViewController {

    @IBOutlet private var typeControl: UISegmentedControl!
    @IBOutlet private var styleControl: UISegmentedControl!
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var messageTextField: UITextField!
    @IBOutlet private var textFieldCountTextField: UITextField!
    @IBOutlet private var buttonCountTextField: UITextField!
    @IBOutlet private var buttonLayoutControl: UISegmentedControl!
    @IBOutlet private var contentControl: UISegmentedControl!

    @IBAction private func presentAlert() {
        if self.typeControl.selectedSegmentIndex == 0 {
            self.presentSDCAlertController()
        } else {
            self.presentUIAlertController()
        }
    }

    private func presentSDCAlertController() {
        let title = self.titleTextField.content
        let message = self.messageTextField.content
        let style = AlertControllerStyle(rawValue: self.styleControl.selectedSegmentIndex)!
        let alert = AlertController(title: title, message: message, preferredStyle: style)
        
        let visualStyle = OwlrVisualStyle(alertStyle: style)
        visualStyle.backgroundColor = UIColor.purpleColor()
        visualStyle.defaultFont = UIFont.italicSystemFontOfSize(12)
        visualStyle.defaultTextColor = UIColor.lightGrayColor()
        visualStyle.preferredFont = UIFont.boldSystemFontOfSize(6)
        visualStyle.preferredTextColor = UIColor.darkGrayColor()
        visualStyle.titleTextColor = UIColor.greenColor()
        visualStyle.messageTextColor = UIColor.brownColor()
        alert.visualStyle = visualStyle
        
        let textFields = Int(self.textFieldCountTextField.content ?? "0")!
        for _ in 0..<textFields {
            alert.addTextFieldWithConfigurationHandler()
        }

        let buttons = Int(self.buttonCountTextField.content ?? "0")!
        for i in 0..<buttons {
            if i == 0 {
                alert.addAction(AlertAction(title: "Cancel", style: .Preferred))
            } else if i == 1 {
                alert.addAction(AlertAction(title: "OK", style: .Default))
            } else if i == 2 {
                alert.addAction(AlertAction(title: "Delete", style: .Destructive))
            } else {
                alert.addAction(AlertAction(title: "Button \(i)", style: .Default))
            }
        }

        alert.actionLayout = ActionLayout(rawValue: self.buttonLayoutControl.selectedSegmentIndex)!

        addContentToAlert(alert)
        alert.present()
    }

    private func addContentToAlert(alert: AlertController) {
        switch self.contentControl.selectedSegmentIndex {
        case 1:
            let contentView = alert.contentView
            let image = UIImage(named: "cheerful_owlr")
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(imageView)
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: [], metrics: nil, views: ["imageView" : imageView]))
            contentView.addConstraint(NSLayoutConstraint(
                item: imageView,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .CenterX,
                multiplier: 1.0,
                constant: 0.0))
        case 2:
            let contentView = alert.contentView
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            contentView.addSubview(spinner)
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[spinner]|", options: [], metrics: nil, views: ["spinner" : spinner]))
            contentView.addConstraint(NSLayoutConstraint(
                item: spinner,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .CenterX,
                multiplier: 1.0,
                constant: 0.0))
        case 3:
            let contentView = alert.contentView
            let bar = UIProgressView(progressViewStyle: .Default)
            bar.translatesAutoresizingMaskIntoConstraints = false
            alert.contentView.addSubview(bar)
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bar]|", options: [], metrics: nil, views: ["bar" : bar]))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[bar]-20-|", options: [], metrics: nil, views: ["bar" : bar]))
            NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector:
                #selector(updateProgressBar), userInfo: bar, repeats: true)
        default: break
        }
    }

    @objc
    private func updateProgressBar(timer: NSTimer) {
        let bar = timer.userInfo as? UIProgressView
        bar?.progress += 0.005

        if bar?.progress >= 1 {
            timer.invalidate()
        }
    }

    private func presentUIAlertController() {
        let title = self.titleTextField.content
        let message = self.messageTextField.content
        let style = UIAlertControllerStyle(rawValue: self.styleControl.selectedSegmentIndex)!
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        let textFields = Int(self.textFieldCountTextField.content ?? "0")!
        for _ in 0..<textFields {
            alert.addTextFieldWithConfigurationHandler(nil)
        }

        let buttons = Int(self.buttonCountTextField.content ?? "0")!
        for i in 0..<buttons {
            if i == 0 {
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            } else if i == 1 {
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            } else if i == 2 {
                alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: nil))
            } else {
                alert.addAction(UIAlertAction(title: "Button \(i)", style: .Default, handler: nil))
            }
        }

        presentViewController(alert, animated: true, completion: nil)
    }
}

private extension UITextField {

    var content: String? {
        if let text = self.text where !text.isEmpty {
            return text
        }

        return self.placeholder
    }
}
