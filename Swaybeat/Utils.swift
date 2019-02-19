import Foundation
import Parse

func ensureUsername() {
  print("trying to ensure username")
  if let name = PFUser.currentUser()?.valueForKey("name") {
    print(name)
  } else {
    let uvc = UsernameViewController(nibName: "UsernameViewController", bundle: nil)
    UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(uvc, animated: true, completion: {
      print("yeah")
    })
  }
}

func ensureLoggedIn() {
  if let user = PFUser.currentUser() {
    print(user)
  } else {
    let lvc = LoginViewController(nibName: "LoginViewController", bundle: nil)
    UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(lvc, animated: true, completion: nil)
    print("yeah")
  }
}

func randomAlphaNumericString(length: Int) -> String {
  
  let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  let allowedCharsCount = UInt32(allowedChars.characters.count)
  var randomString = ""
  
  for _ in (0..<length) {
    let randomNum = Int(arc4random_uniform(allowedCharsCount))
    let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
    randomString += String(newCharacter)
  }
  
  return randomString
}