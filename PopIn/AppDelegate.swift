//
//  AppDelegate.swift
//  PopIn
//
//  Created by Hanny Aly on 4/23/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
//import Foundation

protocol PhotoFeedControllerProtocol {
    func resetAllData()
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
  
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window = window
        
        // SignIn viewController & navController
        let signInVC = SigninNodeController()
        let signInVCNavCtrl = UINavigationController(rootViewController: signInVC)
        signInVCNavCtrl.navigationBarHidden = true
        window.rootViewController = signInVCNavCtrl
        window.makeKeyAndVisible()
        
        
//        let signinVC = SigninViewController()
//        let signInVCNavCtrl = UINavigationController(rootViewController: signinVC)
//        signInVCNavCtrl.navigationBarHidden = true
//        window.rootViewController = signInVCNavCtrl
//        window.makeKeyAndVisible()
        
        

        
        return true
        
        /*
        
        // this UIWindow subclass is neccessary to make the status bar opaque
        let window = WindowWithStatusBarUnderlay(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        
        
        window.rootViewController = PhotoFeedNodeController()
        
        window.makeKeyAndVisible()
        self.window = window
       
        
        // ASDK Home Feed viewController & navController
        let asdkHomeFeedVC: PhotoFeedNodeController = PhotoFeedNodeController()
        let asdkHomeFeedNavCtrl: UINavigationController = UINavigationController(rootViewController: asdkHomeFeedVC)
        asdkHomeFeedNavCtrl.tabBarItem = UITabBarItem(title: "PopRoll", image: UIImage(named: "home"), tag: 1)
        asdkHomeFeedNavCtrl.hidesBarsOnSwipe = true
        
        
        
        // SignIn viewController & navController
        let signInVC: SigninController = SigninController()
        let signInVCNavCtrl: UINavigationController = UINavigationController(rootViewController: signInVC)
        signInVCNavCtrl.tabBarItem = UITabBarItem(title: "Signin", image: UIImage(named: "home"), tag: 0)
        signInVCNavCtrl.hidesBarsOnSwipe = true
        
        
        
        // UITabBarController
        let tabBarController: UITabBarController = UITabBarController()
        
        tabBarController.viewControllers = [signInVC, asdkHomeFeedNavCtrl]
        tabBarController.selectedViewController = signInVC
        tabBarController.delegate = self
        UITabBar.appearance().tintColor = UIColor.blueColor()
        
        
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
        self.window = window

        
        // Nav Bar appearance
        
        let attributes: Dictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = attributes
        navigationBarAppearance.barTintColor = UIColor.blueColor()
        navigationBarAppearance.translucent = false
        
        // iOS8 hides the status bar in landscape orientation, this forces the status bar hidden status to NO
        // [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        // [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        
        return true
 
 */
    }
    
    
    //pragma mark - UITabBarControllerDelegate
    
//    func tabBarController(tabBarController: UITabBarController,
//                          didSelectViewController viewController: UIViewController) {
//        
//        if ([viewController isKindOfClass:[UINavigationController class]]) {
//            NSArray *viewControllers = [(UINavigationController *)viewController viewControllers];
//            UIViewController *rootViewController = viewControllers[0];
//            if ([rootViewController conformsToProtocol:@protocol(PhotoFeedControllerProtocol)]) {
//                // FIXME: the dataModel does not currently handle clearing data during loading properly
//                //      [(id <PhotoFeedControllerProtocol>)rootViewController resetAllData];
//            }
//        }
//    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

