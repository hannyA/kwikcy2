//
//  AWSMobileClient.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.2
//
import Foundation
import UIKit
import AWSCore
import AWSMobileHubHelper
import AWSMobileAnalytics

/**
 * AWSMobileClient is a singleton that bootstraps the app. It creates an identity manager to establish the user identity with Amazon Cognito.
 */
class AWSMobileClient: NSObject {
    // Amazon Mobile Analytics client - Use to generate custom or monetization analytics events.
    var mobileAnalytics: AWSMobileAnalytics!
    
    // Shared instance of this class
    static let sharedInstance = AWSMobileClient()
    private var isInitialized: Bool
    
    private override init() {
        isInitialized = false
        super.init()
    }
    
    deinit {
        // Should never be called
        print("Mobile Client deinitialized. This should not happen.")
    }
    
    /**
     * Configure third-party services from application delegate with url, application
     * that called this provider, and any annotation info.
     *
     * - parameter application: instance from application delegate.
     * - parameter url: called from application delegate.
     * - parameter sourceApplication: that triggered this call.
     * - parameter annotation: from application delegate.
     * - returns: true if call was handled by this component
     */
    func withApplication(application: UIApplication, withURL url: NSURL, withSourceApplication sourceApplication: String?, withAnnotation annotation: AnyObject) -> Bool {
        print("withApplication:withURL")
        AWSIdentityManager.defaultIdentityManager().interceptApplication(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
        if (!isInitialized) {
            isInitialized = true
        }
        
        return false;
    }
    
    /**
     * Performs any additional activation steps required of the third party services
     * e.g. Facebook
     *
     * - parameter application: from application delegate.
     */
    func applicationDidBecomeActive(application: UIApplication) {
        initializeMobileAnalytics()
    }
    
    private func initializeMobileAnalytics() {
        if (mobileAnalytics == nil) {
            mobileAnalytics = AWSMobileAnalytics.defaultMobileAnalytics()
        }
    }
    /**
    * Handles callback from iOS platform indicating push notification registration was a success.
    * - parameter application: application
    * - parameter deviceToken: device token
    */
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        AWSPushManager.defaultPushManager().interceptApplication(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    /**
     * Handles callback from iOS platform indicating push notification registration failed.
     * - parameter application: application
     * - parameter error: error
     */
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        AWSPushManager.defaultPushManager().interceptApplication(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    /**
     * Handles a received push notification.
     * - parameter userInfo: push notification contents
     */
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        AWSPushManager.defaultPushManager().interceptApplication(application, didReceiveRemoteNotification: userInfo)
    }
    
    /**
    * Configures all the enabled AWS services from application delegate with options.
    *
    * - parameter application: instance from application delegate.
    * - parameter launchOptions: from application delegate.
    */
    func didFinishLaunching(application: UIApplication, withOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        print("didFinishLaunching:")

        var didFinishLaunching: Bool = AWSIdentityManager.defaultIdentityManager().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)
//        didFinishLaunching = didFinishLaunching
            //&& AWSPushManager.defaultPushManager().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)

        if (!isInitialized) {
            AWSIdentityManager.defaultIdentityManager().resumeSessionWithCompletionHandler({(result: AnyObject?, error: NSError?) -> Void in
                print("Result: \(result) \n Error:\(error)")
            })
            isInitialized = true
        }

        return didFinishLaunching
    }
}
