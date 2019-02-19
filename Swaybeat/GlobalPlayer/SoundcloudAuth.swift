import Foundation

let soundcloudClientId = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Keys", ofType: "plist")!)!.valueForKey("soundcloudClientId") as! String

class SoundcloudAuth {
    
  static let sharedInstance = SoundcloudAuth()
  
  var clientId: String!
  
  init() {
    clientId = soundcloudClientId
  }
  
}