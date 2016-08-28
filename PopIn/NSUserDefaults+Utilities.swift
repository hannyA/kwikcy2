//
//  HAExtensions.swift
//  PopIn
//
//  Created by Hanny Aly on 8/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import SwiftyUserDefaults


extension DefaultsKeys {
    static let useLessData  = DefaultsKey<Bool>("DataUse")
    static let launchCount  = DefaultsKey<Int>("launchCount")
}

extension NSUserDefaults {

    
    static func isFirstLaunchEver() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"

        if !standardUserDefaults().boolForKey(firstLaunchFlag) {
            standardUserDefaults().setBool(true, forKey: firstLaunchFlag)
            return true
        }
        return false
    }
    
    // For multi user login
    func isFirstLaunchForUser(user: String) -> Bool {

        if !boolForKey(user) {
            setBool(true, forKey: user)
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