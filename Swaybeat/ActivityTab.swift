import UIKit

class ActivityTab: UINavigationController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    let tabBarItemImage = UIImage(named: "ActivityTabBarIcon")
    tabBarItem = UITabBarItem(title: "Activity", image: tabBarItemImage, tag: 1)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewControllers = [ActivityPage()]
  }
  
}
