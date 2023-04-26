import UIKit

class BaseViewController: UIViewController {

  var keyboardHeightAdjustment: CGFloat = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  @objc func keyboardWillShow(notification: Notification) {
    guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
      return
    }

    let keyboardHeight = keyboardSize.height * keyboardHeightAdjustment

    UIView.animate(withDuration: 0.25) {
      self.view.frame.origin.y = -keyboardHeight
    }
  }

  @objc func keyboardWillHide(notification: Notification) {
    UIView.animate(withDuration: 0.25) {
      self.view.frame.origin.y = 0
    }
  }

  @objc func dismissKeyboard() {
      view.endEditing(true)
  }

}
