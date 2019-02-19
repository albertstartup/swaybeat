import UIKit

class PeopleRecommendationTab: UINavigationController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    let tabBarItemImage = UIImage(named: "PeopleTabBarIcon")
    tabBarItem = UITabBarItem(title: "People", image: tabBarItemImage, tag: 3)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewControllers = [PeopleListPage()]
  }
  
}
