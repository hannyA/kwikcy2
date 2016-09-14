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
import BigBrother
import SwiftyDrop

class HATabBarController: UITabBarController, UITabBarControllerDelegate, HAPresentAppDelegate {
    
    var willEnterForegroundObserver: AnyObject!
    
    var viewWillAppearFromSignIn = false

    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        print("HATabbar viewDidLoad")
        
        
        // Called when app is reopened
        willEnterForegroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification,
                                                            object: nil,
                                                            queue: NSOperationQueue.currentQueue()) { _ in
        
                                      
            print("HATabbar viewDidLoad willEnterForegroundObserver")

        }

        
        
        // Do any additional setup after loading the view.
        delegate = self
        
        
        // 1 Tab) Following ViewController
        let followingVC = HAFollowingVC()
        followingVC.delegate = self
        
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
        hideSelf()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
   }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("HATabar viewWillAppear")
    }
    
   
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("HATabar viewDidAppear")
    }
    
    
    
    
    
    func handleLogoutWithMessage(message: String?) {
       
        AWSIdentityManager.defaultIdentityManager().logoutWithCompletionHandler({(result: AnyObject?, error: NSError?) -> Void in
            
            print("Result: \(result), Error: \(error)")            
            
            if let message = message {
                Drop.down("\(message)",
                    state: .Error ,
                    duration: 4.0,
                    action: nil)
            }
            else if let errorMessage = AWSConstants.errorMessage(error) {
                print("errorMessage: \(errorMessage)")
            }
            
            Me.sharedInstance.wipeData()
            
            self.presentSignInController(nil)
        })
    }
    
    
    
    
    func logoutFacebookUser() {
        
        print("logoutFacebookUser")
        if AWSIdentityManager.defaultIdentityManager().loggedIn {
            print("logoutFacebookUser loggedIn")
            
            
            AWSIdentityManager.defaultIdentityManager().logoutWithCompletionHandler({(result: AnyObject?, error: NSError?) -> Void in
                
                print("Result: \(result), Error: \(error)")
                
                
                if let errorMessage = AWSConstants.errorMessage(error) {
                    
                    print("errorMessage: \(errorMessage)")
                }
                
                if Me.sharedInstance.wipeData() {
                    print("Wiped away all data")
                } else {
                    print("Unable to wipe away all data")
                }
                
                self.presentSignInController(nil)
            })
        } else {
            print("logoutFacebookUser loggedIn error?")
            
            Me.sharedInstance.wipeData()
            
            self.presentSignInController(nil)
            
            //Show could not log out...
        }
    }

    
    

    
    
    func presentSignInController(message: String?) {
        
        if let message = message {
            
            Drop.down("\(message)",
                      state: .Error ,
                      duration: 4.0,
                      action: nil)
        }
        
        let signInVC = SignInVC()
        let signInVCNavCtrl = UINavigationController(rootViewController: signInVC)
        signInVCNavCtrl.setNavigationBarHidden(true, animated: false)
        
        presentViewController(signInVCNavCtrl, animated: false) { 
            
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
    
    
    
    func presentRegisterController(message: String?) {
        
        if let message = message {
            
            Drop.down("\(message)",
                      state: .Error ,
                      duration: 4.0,
                      action: nil)
            
        }
        
        let signInVC = SignInVC()
        let signInVCNavCtrl = UINavigationController(rootViewController: signInVC)
        signInVCNavCtrl.setNavigationBarHidden(true, animated: false)
        
        print("Push register")
        
        let vc = RegisterUserVC()
        vc.delegate = signInVC
        signInVCNavCtrl.navigationController?.pushViewController(vc, animated: false)
        
        presentViewController(signInVCNavCtrl, animated: false) {
            
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewControllerAnimated(false)
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    func showSelf() {
        view.alpha = 1.0
    }

    
    func showSelfWithAnimation() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn , animations: {
            self.view.alpha = 1.0
        }, completion: nil)
    }
    
    
    func hideSelf() {
        view.alpha = 0.0
    }
    
    
    func hideSelfWithAnimation() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut , animations: {
            self.view.alpha = 0.0
        }, completion: nil)
    }
}
