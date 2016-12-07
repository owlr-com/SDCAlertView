import UIKit
import SDCAlertView

final class DemoViewController: UITableViewController {

    @IBOutlet fileprivate var typeControl: UISegmentedControl!
    @IBOutlet fileprivate var styleControl: UISegmentedControl!
    @IBOutlet fileprivate var titleTextField: UITextField!
    @IBOutlet fileprivate var messageTextField: UITextField!
    @IBOutlet fileprivate var textFieldCountTextField: UITextField!
    @IBOutlet fileprivate var buttonCountTextField: UITextField!
    @IBOutlet fileprivate var buttonLayoutControl: UISegmentedControl!
    @IBOutlet fileprivate var contentControl: UISegmentedControl!

    @IBAction fileprivate func presentAlert() {
        if self.typeControl.selectedSegmentIndex == 0 {
            self.presentSDCAlertController()
        } else {
            self.presentUIAlertController()
        }
    }

    fileprivate func presentSDCAlertController() {
        let title = self.titleTextField.content
        let message = self.messageTextField.content
        let style = AlertControllerStyle(rawValue: self.styleControl.selectedSegmentIndex)!
        let alert = AlertController(title: title, message: message, preferredStyle: style)
        
        let visualStyle = AlertVisualStyle(alertStyle: style)
        
        visualStyle.backgroundColor = UIColor.white
        
        visualStyle.titleTextColor = UIColor.darkText
        visualStyle.messageTextColor = UIColor.darkText

        visualStyle.normalFont = UIFont.boldSystemFont(ofSize: 15)
        visualStyle.normalTextColor = UIColor.white
        visualStyle.normalButtonColor = UIColor.lightGray

        visualStyle.preferredFont = UIFont.boldSystemFont(ofSize: 15)
        visualStyle.preferredTextColor = UIColor.white
        visualStyle.preferredButtonColor = UIColor.blue
        
        visualStyle.destructiveFont = UIFont.italicSystemFont(ofSize: 15)
        visualStyle.destructiveTextColor = UIColor.darkText
        visualStyle.destructiveButtonColor = UIColor.white
        
        alert.visualStyle = visualStyle
        
        let textFields = Int(self.textFieldCountTextField.content ?? "0")!
        for _ in 0..<textFields {
            alert.addTextField()
        }

        let buttons = Int(self.buttonCountTextField.content ?? "0")!
        for i in 0..<buttons {
            if i == 0 {
                alert.add(AlertAction(title: "Cancel", style: .preferred))
            } else if i == 1 {
                alert.add(AlertAction(title: "OK", style: .normal))
            } else if i == 2 {
                alert.add(AlertAction(title: "Delete", style: .destructive))
            } else {
                alert.add(AlertAction(title: "Button \(i)", style: .normal))
            }
        }

        alert.actionLayout = ActionLayout(rawValue: self.buttonLayoutControl.selectedSegmentIndex)!

        addContentToAlert(alert)
        alert.present()
    }

    fileprivate func addContentToAlert(_ alert: AlertController) {
        switch self.contentControl.selectedSegmentIndex {
        case 1:
            let contentView = alert.contentView
            let image = UIImage(named: "cheerful_owlr")
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(imageView)
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: [], metrics: nil, views: ["imageView" : imageView]))
            contentView.addConstraint(NSLayoutConstraint(
                item: imageView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0))
        case 2:
            let contentView = alert.contentView
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            contentView.addSubview(spinner)
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[spinner]|", options: [], metrics: nil, views: ["spinner" : spinner]))
            contentView.addConstraint(NSLayoutConstraint(
                item: spinner,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0))
        case 3:
            let contentView = alert.contentView
            let bar = UIProgressView(progressViewStyle: .default)
            bar.translatesAutoresizingMaskIntoConstraints = false
            alert.contentView.addSubview(bar)
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bar]|", options: [], metrics: nil, views: ["bar" : bar]))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[bar]-20-|", options: [], metrics: nil, views: ["bar" : bar]))
            Timer.scheduledTimer(timeInterval: 0.01,
                                 target: self,
                                 selector: #selector(updateProgressBar),
                                 userInfo: bar,
                                 repeats: true)
        default: break
        }
    }

    @objc
    fileprivate func updateProgressBar(_ timer: Timer) {
        let bar = timer.userInfo as? UIProgressView
        bar?.progress += 0.005

        if let progress = bar?.progress, progress >= 1.0 {
            timer.invalidate()
        }
    }

    fileprivate func presentUIAlertController() {
        let title = self.titleTextField.content
        let message = self.messageTextField.content
        let style = UIAlertControllerStyle(rawValue: self.styleControl.selectedSegmentIndex)!
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        let textFields = Int(self.textFieldCountTextField.content ?? "0")!
        for _ in 0..<textFields {
            alert.addTextField(configurationHandler: nil)
        }

        let buttons = Int(self.buttonCountTextField.content ?? "0")!
        for i in 0..<buttons {
            if i == 0 {
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            } else if i == 1 {
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            } else if i == 2 {
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: nil))
            } else {
                alert.addAction(UIAlertAction(title: "Button \(i)", style: .default, handler: nil))
            }
        }

        present(alert, animated: true, completion: nil)
    }
}

private extension UITextField {

    var content: String? {
        if let text = self.text, !text.isEmpty {
            return text
        }

        return self.placeholder
    }
}
