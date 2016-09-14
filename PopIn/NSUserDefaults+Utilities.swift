//
//  HAExtensions.swift
//  PopIn
//
//  Created by Hanny Aly on 8/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import SwiftyUserDefaults


//extension DefaultsKeys {
//    
//    static let useLessData          = DefaultsKey<Bool>("DataUse")
//    static let isFirstLaunch        = DefaultsKey<Bool>("FirstLaunch")
////    static let launchCount          = DefaultsKey<Int>("LaunchCount")
////    static let isFirstLaunchForuser = DefaultsKey<Bool>("FirstLaunchForUser")
//    
//    
////    What we wanna do is query user last version use, in 'users' table in MySQL
//    // That way we know how much they've used the app.
//    
////    func firstLaunchForUser(username: String) {
////        let colorKey = DefaultsKey<String>(username)
////        
////    }
////
//}

extension NSUserDefaults {

    
    class func isFirstLaunchEver() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"

        if !standardUserDefaults().boolForKey(firstLaunchFlag) {
            standardUserDefaults().setBool(true, forKey: firstLaunchFlag)
            return true
        }
        return false
    }
    
    
    
    // For multi user login
    func isFirstLaunchForUserPushNotifications(user: String) -> Bool {

        let key = "\(user)-PushNotifications"
        
        if !boolForKey(key) {
            setBool(true, forKey: key)
            return true
        }
        return false
    }
    
    
    // For multi user login
    class func useLessData(less: Bool) {
        
        standardUserDefaults().setBool(less, forKey: uDataUse)
        
    }
    
    // For multi user login
    class func shouldUseLessData() -> Bool {
        
        return standardUserDefaults().boolForKey(uDataUse)
        
    }
}