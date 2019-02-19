import UIKit
import DynamicColor

let SwaybeatPink = UIColor(hexString: "#E91E63")

func setSwaybeatAppearance() {
  
  UINavigationBar.appearance().barTintColor = SwaybeatPink
  UINavigationBar.appearance().translucent = false
  UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

  UITabBar.appearance().backgroundColor = .whiteColor()
  UITabBar.appearance().tintColor = SwaybeatPink
  UITabBar.appearance().translucent = false
  
}