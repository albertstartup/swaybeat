import Foundation
import AVFoundation

let userDefaults = NSUserDefaults.standardUserDefaults()

func setupSpotify() {
  
  SPTAuth.defaultInstance().clientID = "fake"
  SPTAuth.defaultInstance().redirectURL = NSURL(string: "swaybeat-spotify-login://returnafterlogin")
  SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
  SPTAuth.defaultInstance().tokenRefreshURL = NSURL(string: "http://192.168.1.139:1234/refresh")
  SPTAuth.defaultInstance().tokenSwapURL = NSURL(string: "http://192.168.1.139:1234/swap")
  SPTAuth.defaultInstance().sessionUserDefaultsKey = "SpotifySession"
  
  /*if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") {
    
    let sessionDataObj = sessionObj as! NSData
    let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
    
    if !session.isValid() {
      
      SPTAuth.defaultInstance().renewSession(session, callback: { (error:NSError!, renewdSession:SPTSession!) -> Void in
        
        if error == nil {
          
          let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
          userDefaults.setObject(sessionData, forKey: "SpotifySession")
          userDefaults.synchronize()
          
          print("success refreshing session")
          loginSpotifyPlayer(session)
        }else{
          print("error refreshing session")
        }
      })
      
    }else{
      
      print("session valid")
      print("session expiration date: \(session.expirationDate)")
      loginSpotifyPlayer(session)
    }
    
  } else {
    
    let loginURL = SPTAuth.defaultInstance().loginURL
    
    UIApplication.sharedApplication().performSelector("openURL:", withObject: loginURL, afterDelay: 0.5)
  }*/
  
}

func loginSpotifyPlayer(session: SPTSession) {
  
  SpotifyInternalPlayer.loginWithSession(session, callback: {error in
    if (error != nil) {
      print("error player loginin: \(error)")
      return
    }
    
    print("player logged in")
  })
  
}

func handleSpotifyLoginCallback(url: NSURL) {
  SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url) { (error: NSError!, session: SPTSession!) in
    
    if (error != nil) {
      print("error handling spotify login call back: \(error)")
      return
    }
    
    let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
    userDefaults.setObject(sessionData, forKey: "SpotifySession")
    userDefaults.synchronize()
    
    print("login success: \(session)")
    
    loginSpotifyPlayer(session)
    
  }
}

func checkIfSpotifyLoginCallback(url: NSURL) -> Bool {
  if SPTAuth.defaultInstance().canHandleURL(url) {
    handleSpotifyLoginCallback(url)
  }
  
  return true
}