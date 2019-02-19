import UIKit
import Parse

class UsernameViewController: UIViewController {
  
  @IBOutlet weak var usernameInput: UITextField!    
  
  @IBAction func touchedGo(sender: AnyObject) {
    print(usernameInput.text)
    PFUser.currentUser()?.setValue(usernameInput.text, forKey: "name")
    PFUser.currentUser()?.saveEventually()
    self.dismissViewControllerAnimated(true) {print("yeet!")}
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
  
}
