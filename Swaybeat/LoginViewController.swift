import UIKit
import DigitsKit
import Parse

class LoginViewController: UIViewController {
  
  /*override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }*/
  
  @IBAction func didTouchLoginButton() {
    let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
    let appearance = DGTAppearance()
    appearance.accentColor = SwaybeatPink
    configuration.appearance = appearance
    PFUser.loginWithDigitsInBackgroundWithConfiguration(configuration) { session, error in
      if (error != nil) {
        print(error)
        return
      }
      print(session)
      
      UIApplication.sharedApplication().keyWindow!.rootViewController!.dismissViewControllerAnimated(true) {
        ensureUsername()
      }
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
