//
//  AppDelegate.swift
//  PopIn
//
//  Created by Hanny Aly on 4/23/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

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
//        let signInVC = RegisterUserVC()
//        let signInVCNavCtrl = UINavigationController(rootViewController: signInVC)

        let tabbarVC = HATabBarController()
        let signInVCNavCtrl = UINavigationController(rootViewController: tabbarVC)
        signInVCNavCtrl.navigationBarHidden = true
        window.rootViewController = signInVCNavCtrl
        window.makeKeyAndVisible()
        
        
        
        
        if Defaults[.isFirstLaunch] {
            print("First launch")
        } else {
            print("Not First launch")
        }
        
        
        let versionNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let buildNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
        
    
        print("versionNumber: \(versionNumber), buildNumber: \(buildNumber)")
        
        

        //MARK: Uncomment this line
        return AWSMobileClient.sharedInstance.didFinishLaunching(application, withOptions: launchOptions)
//        return true
        
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
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // print("application application: \(application.description), openURL: \(url.absoluteURL), sourceApplication: \(sourceApplication)")
        return AWSMobileClient.sharedInstance.withApplication(application, withURL: url, withSourceApplication: sourceApplication, withAnnotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

    }
    
    
    //MARK: Uncomment below

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AWSMobileClient.sharedInstance.applicationDidBecomeActive(application)
    }
//
//    func applicationWillTerminate(application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
//    
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        AWSMobileClient.sharedInstance.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
//    }
//    
//    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        AWSMobileClient.sharedInstance.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
//    }
//    
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        AWSMobileClient.sharedInstance.application(application, didReceiveRemoteNotification: userInfo)
//    }

}

