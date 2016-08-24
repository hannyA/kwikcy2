//
//  HAProfileEditResponse.swift
//  PopIn
//
//  Created by Hanny Aly on 8/23/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation

class HAProfileEditResponse {
    
    var newData: HAEditProfileVC.UserData
    var errorMessage: String?
    
    init?(response result: AnyObject?) {
        
        if result == nil {
            return nil
        } else if let response = result as? [String: AnyObject]  {
            newData = HAEditProfileVC.UserData()

            if let message = response[kErrorMessage] as? String {
                errorMessage = message
            } else if let profile = response[kProfile] as? [String: String] {
                
                print("profile: \(profile)")
                newData.username = profile[kUserName]
                newData.fullname = profile[kFullName]
                newData.website  = profile[kDomain]
                newData.bio      = profile[kAbout]
                newData.email    = profile[kEmail]
                newData.mobile   = profile[kMobile]
                newData.gender   = profile[kGender]
            } 
        } else {
            return nil
        }
    }
}