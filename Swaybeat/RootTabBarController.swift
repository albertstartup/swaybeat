import UIKit
import DigitsKit

class RootTabBarController: UITabBarController {
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    viewControllers = [ActivityTab(), SongShareTab()]
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    becomeFirstResponder()
    UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    
    ensureLoggedIn()
  }
  
  override func canBecomeFirstResponder() -> Bool {
    return true
  }
}

extension RootTabBarController {
  override func remoteControlReceivedWithEvent(event: UIEvent?) {
    let subtype = event!.subtype
    
    switch subtype {
    case .RemoteControlTogglePlayPause:
      print("toggle")
      GlobalPlayer.sharedInstance.togglePlayPause()
    case .RemoteControlPlay:
      print("play")
      GlobalPlayer.sharedInstance.resume()
    case .RemoteControlPause:
      print("pause")
      GlobalPlayer.sharedInstance.pause()
    default: break
    }

  }
}
