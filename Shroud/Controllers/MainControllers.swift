//
//  MainControllers.swift
//  Shroud
//
//  Created by Lynk on 9/9/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class MainControllers: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let friend = FriendListViewController()
        friend.title = "Shroud"
        let friendNav = UINavigationController(rootViewController:friend )
        friendNav.title = "Friends"
        viewControllers = [friendNav]
        self.tabBar.barTintColor = ShroudColors.darkGray
        self.tabBar.tintColor = .white
        self.tabBar.isTranslucent = false
        
    }
     

}
