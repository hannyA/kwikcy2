//
//  LambdaLoginResponse.swift
//  PopIn
//
//  Created by Hanny Aly on 7/27/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation


let kSavedImage     = "SavedImage"
let kUserExists     = "UserExists"
let kProfiles       = "Profiles"

class LambdaLoginResponse {
    
    struct User {
        var guid    :String
        var acctId  :String
        var active  :Int

        var username:String
        var fullname:String?
        var about   :String?
        var domain  :String?
        var verified:Bool
        var gender  :Int?
    }
    
    
    
    
    let savedImage: Bool
    var profiles: [User]
    
    
    init?(response result: AnyObject?) {

        if result == nil {
            return nil
        } else if let response  = result as? [String: AnyObject]  {
            
            if let _  = response[kErrorMessage] as? String {
                return nil
            }
            
            if let savedImage = response[kSavedImage] as? Bool {
                self.savedImage = savedImage
            } else {
                savedImage = false
            }
            
            profiles = [User]()
            if let usersProfiles = response[kProfiles] as? [ AnyObject ] {
                
                for profile in usersProfiles {
                    
                    let acctId      = profile[kAcctId]   as! String
                    let guid        = profile[kGuid]     as! String
                    let active      = profile[kActive]   as! Int

                    let username    = profile[kUserName] as! String
                    let verified    = profile[kVerified] as! Bool
                    let fullname    = profile[kFullName] as? String
                    let about       = profile[kAbout]    as? String
                    let domain      = profile[kDomain]   as? String
                    let gender      = profile[kGender]   as? Int

                    let user = User(guid: guid,
                                    acctId: acctId,
                                    active: active,
                                    username: username,
                                    fullname: fullname,
                                    about: about,
                                    domain: domain,
                                    verified: verified,
                                    gender: gender)
                    

                    profiles.append(user)
                }
            } else {

                return nil
            }
        } else {

            return nil
        }
    }
    
    
    func hasOneProfile() -> Bool {
        return profiles.count == 1
    }

}