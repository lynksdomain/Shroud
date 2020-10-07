//
//  MainControllers.swift
//  Shroud
//
//  Created by Lynk on 9/9/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class MainControllers: UITabBarController {
    let friend = FriendListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        friend.title = "Shroud"
//        let friendNav = UINavigationController(rootViewController:friend )
//        friendNav.title = "Friends"
        viewControllers = [friend]
        self.tabBar.barTintColor = ShroudColors.darkGray
        self.tabBar.tintColor = .white
        self.tabBar.isTranslucent = false
        
    }
    func setDelegateToFriendList(_ vc: SignInViewController) {
        vc.delegate = friend
    }

}
