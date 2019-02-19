import UIKit
import Fabric
import DigitsKit
import Crashlytics
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    setSwaybeatAppearance()
    
    setupWindow()
    
    setupSpotify()
    
    Fabric.sharedSDK().debug = true
        
    Fabric.with([Crashlytics.self, Digits.self])
    
    setupParse(["LaunchOptions": launchOptions])
    
    // FIXME: DELETE BEFORE PRODUCTION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //tempResetAccounts()
    //tempResetAccounts()
    //tempCreateAccount()
    //tempsignIn()
    
    return true
  }
  
  func tempsignIn() {
    do {
      try PFUser.logInWithUsername("ari", password: "pass")
    } catch {
      print("failed to login test account")
    }
  }
  
  func tempCreateAccount() {
    let user = PFUser()
    user.password = ""
    user.username = ""
    user["name"] = user.username
    do {
      try user.signUp()
    } catch {
      print("failed to singup test account")
    }
  }
  
  func tempResetAccounts() {
    PFUser.logOut()
    Digits.sharedInstance().logOut()
    /*do {
      try Locksmith.deleteDataForUserAccount("digitsAuth")
    } catch {
      print("could not delete")
    }*/
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    
    //checkIfSpotifyLoginCallback(url)
    
    return false
  }
  
  func setupParse(config: [String: AnyObject?]) {
    let launchOptions = config["LaunchOptions"] as? [NSObject: AnyObject]
    
    Parse.enableLocalDatastore()
    
    Parse.setApplicationId("",
      clientKey: "")
    
    PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
  }
  
  func setupWindow() {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window!.rootViewController = RootTabBarController()
    window!.makeKeyAndVisible()
    
    // Set share song tab as initial tab
    if let tabBarController = window!.rootViewController as? UITabBarController {
      tabBarController.selectedIndex = 1
    }
  }
  
}

