
//
//  SongSearchTab.swift
//  Swaybeat
//
//  Created by human on 12/21/15.
//  Copyright © 2015 Swaybeat. All rights reserved.
//

import UIKit

class SongShareTab: UINavigationController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    let tabBarItemImage = UIImage(named: "ShareTabBarIcon")
    tabBarItem = UITabBarItem(title: "Share", image: tabBarItemImage, tag: 2)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewControllers = [SongSearchPage()]
  }
  
}
