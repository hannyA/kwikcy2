//
//  HATabBarController.swift
//  PopIn
//
//  Created by Hanny Aly on 5/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
import AWSMobileHubHelper
import SwiftIconFont

class HATabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var willEnterForegroundObserver: AnyObject!
    
    var viewWillAppearFromSignIn = false

    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        willEnterForegroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification,
                                                            object: nil,
                                                            queue: NSOperationQueue.currentQueue()) { _ in
        }

        
        
        // Do any additional setup after loading the view.
        delegate = self
        
        
        // 1 Tab) Following ViewController
        let followingVC = HAFollowingVC()
        let followingNavCtrl = UINavigationController(rootViewController: followingVC)
        followingNavCtrl.navigationBarHidden  = false
        
        let followingIcon = UITabBarItem()
        followingIcon.title = "Following"
        followingIcon.icon(from: .Ionicon, code: "ios-home-outline", imageSize: CGSizeMake(35, 35), ofSize: 35)

        
        followingNavCtrl.tabBarItem = followingIcon
        
        // 2 Tab) Search ViewController
        let discoveryVC = HASearchTableVC()
        let discoveryNavCtrl = UINavigationController(rootViewController: discoveryVC)
        let discoveryIcon = UITabBarItem()
        
        discoveryIcon.icon(from: .Ionicon, code: "ios-search", imageSize: CGSizeMake(35, 35), ofSize: 35)
        discoveryIcon.title = "Search"

        discoveryNavCtrl.tabBarItem = discoveryIcon
        
        
        // 3 Tab) Settings ViewController
        let settingsVC = HAChitChatVC()
        let settingsNavCtrl = UINavigationController(rootViewController: settingsVC)
        
        let settingsIcon = UITabBarItem()
        settingsIcon.icon(from: .Ionicon, code: "ios-bell-outline", imageSize: CGSizeMake(35, 35), ofSize: 35)
        settingsIcon.title = "Camera"

        settingsNavCtrl.tabBarItem = settingsIcon
        
    
        // 4 Tab) Notification ViewController
        let notificationVC = HANotificationVC()
        let notificationVCNavCtrl = UINavigationController(rootViewController: notificationVC)
        let navigationIcon = UITabBarItem()
        navigationIcon.icon(from: .Ionicon, code: "ios-bell-outline", imageSize: CGSizeMake(35, 35), ofSize: 35)

        navigationIcon.title = "Notifications"
        notificationVCNavCtrl.tabBarItem = navigationIcon
        
        
        // 5 Tab) Settings ViewController
        let profileVC = HAProfileVC()
        let profileVCNavCtrl = UINavigationController(rootViewController: profileVC)
        let profileIcon = UITabBarItem()
        profileIcon.icon(from: .Ionicon, code: "ios-person-outline", imageSize: CGSizeMake(35, 35), ofSize: 35)

        profileIcon.title = "Profile/Settings"


        profileVCNavCtrl.tabBarItem = profileIcon
        
        // Combine them
        //array of the root view controllers displayed by the tab bar interface
        let controllers = [followingNavCtrl, discoveryNavCtrl, settingsNavCtrl, notificationVCNavCtrl, profileVCNavCtrl]
        viewControllers = controllers
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
//        NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: willEnterForegroundObserver)
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("HATabar viewWillAppear")

        view.alpha = 0.0
        presentSignInViewController()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("HATabar viewDidAppear")

        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn , animations: {
            self.view.alpha = 1.0
        }, completion: nil)
    }
    
    
    func presentSignInViewController() {
        print("HATabar presentSignInViewController")


        if !AWSIdentityManager.defaultIdentityManager().loggedIn || Me.guid() == nil {
            print("HATabar !AWSIdentityManager")

            let signInVC = SignInVC()
            let notificationVCNavCtrl = UINavigationController(rootViewController: signInVC)
            notificationVCNavCtrl.setNavigationBarHidden(true, animated: false)
            presentViewController(notificationVCNavCtrl, animated: false, completion: nil)
        } else {
            print("HATabar defaultIdentityManager loggedIn: \(AWSIdentityManager.defaultIdentityManager().loggedIn) Me.guid: \(Me.guid())")

        }
    }
    
    func hideSelf() {
        view.alpha = 0.0
    }
}
