//
//  HATabBarController.swift
//  PopIn
//
//  Created by Hanny Aly on 5/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit

class HATabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
        
        
        // 1 Tab) Following ViewController
        let followingVC = HAFollowingVC2()
        let followingNavCtrl = UINavigationController(rootViewController: followingVC)
        followingNavCtrl.navigationBarHidden  = false
        let followingIcon = UITabBarItem(title: "Follow",
                                         image: UIImage(named: "home-7"),
                                         selectedImage: UIImage(named: "home-7"))
        followingNavCtrl.tabBarItem = followingIcon
        
        // 2 Tab) Search ViewController
        let discoveryVC = HASearchTableVC()
        let discoveryNavCtrl = UINavigationController(rootViewController: discoveryVC)
        let discoveryIcon = UITabBarItem(title: "Search",
                                         image: UIImage(named: "star-7"),
                                         selectedImage: UIImage(named: "star-7"))
        discoveryNavCtrl.tabBarItem = discoveryIcon
        
        
        // 3 Tab) Settings ViewController
        let settingsVC = HAChitChatVC()
        let settingsNavCtrl = UINavigationController(rootViewController: settingsVC)
        let settingsIcon = UITabBarItem(title: "ChitChat",
                                        image: UIImage(named: "pin-map-7"),
                                        selectedImage: UIImage(named: "pin-map-7"))
        settingsNavCtrl.tabBarItem = settingsIcon
        
    
        // 4 Tab) Notification ViewController
        let notificationVC = HANotificationVC()
        let notificationVCNavCtrl = UINavigationController(rootViewController: notificationVC)
        let navigationIcon = UITabBarItem(title: "Notifications",
                                          image: UIImage(named: "bell-7"),
                                          selectedImage: UIImage(named: "bell-7"))
        notificationVCNavCtrl.tabBarItem = navigationIcon
        
        
        // 5 Tab) Settings ViewController
        let profileVC = HAProfileVC()
        let profileVCNavCtrl = UINavigationController(rootViewController: profileVC)
        let profileIcon = UITabBarItem(title: nil,
                                       image: UIImage(named: "profile"),
                                       selectedImage: UIImage(named: "profile"))
        profileVCNavCtrl.tabBarItem = profileIcon
        
        // Combine them
        //array of the root view controllers displayed by the tab bar interface
        let controllers = [followingNavCtrl, discoveryNavCtrl, settingsNavCtrl, notificationVCNavCtrl, profileVCNavCtrl]
        viewControllers = controllers
    }


    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        // 1 Tab) Following ViewController
//        let followingVC = HAFollowingVC()
//        let followingNavCtrl = UINavigationController(rootViewController: followingVC)
//        
//        followingNavCtrl.navigationBarHidden  = false
//        
//        let followingIcon = UITabBarItem(title: "Following",
//                                 image: UIImage(named: "home-7"),
//                                 selectedImage: UIImage(named: "home-7"))
//        
//        followingNavCtrl.tabBarItem = followingIcon
//
//        // 2 Tab) Search ViewController
//
//        let discoveryVC = HASearchVC()
//        
//        let discoveryNavCtrl = UINavigationController(rootViewController: discoveryVC)
//
//        let discoveryIcon = UITabBarItem(title: "Search",
//                                         image: UIImage(named: "star-7"),
//                                         selectedImage: UIImage(named: "star-7"))
//       
//        discoveryNavCtrl.tabBarItem = discoveryIcon
//        
//       
//        
//        
//        
//        // 3 Tab) Settings ViewController
//        
//        let settingsVC = HAChitChatVC()
//        let settingsNavCtrl = UINavigationController(rootViewController: settingsVC)
//        
//        let settingsIcon = UITabBarItem(title: "ChitChat",
//                                         image: UIImage(named: "pin-map-7"),
//                                         selectedImage: UIImage(named: "pin-map-7"))
//        
//        settingsNavCtrl.tabBarItem = settingsIcon
//        
//        
//        
//        
//        // 4 Tab) Notification ViewController
//        
//        let notificationVC = HANotification()
//        let notificationVCNavCtrl = UINavigationController(rootViewController: notificationVC)
//        
//        let navigationIcon = UITabBarItem(title: "Notifications",
//                                       image: UIImage(named: "bell-7"),
//                                       selectedImage: UIImage(named: "bell-7"))
//        
//        notificationVCNavCtrl.tabBarItem = navigationIcon
//       
//        
//        
//        
//        // 5 Tab) Settings ViewController
//        
//        let profileVC = HAProfile()
//        let profileVCNavCtrl = UINavigationController(rootViewController: profileVC)
//        
//        let profileIcon = UITabBarItem(title: nil,
//                                        image: UIImage(named: "profile"),
//                                        selectedImage: UIImage(named: "profile"))
//        
//        profileVCNavCtrl.tabBarItem = profileIcon
//        
//        
//        
//        
//        
//        //array of the root view controllers displayed by the tab bar interface
//        let controllers = [followingNavCtrl, discoveryNavCtrl, settingsNavCtrl, notificationVCNavCtrl, profileVCNavCtrl]
//        viewControllers = controllers
//    }
    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }

  

}
