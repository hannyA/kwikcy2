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
        var guid:String
        var acctId:String
        var username:String
    }
    
    let userExists: Bool
    let savedImage: Bool
    var profiles: [User]
    
    
    init?(response result: AnyObject?) {

        if result == nil {
            return nil
        } else if let response  = result as? [String: AnyObject]  {
            
            if (response[kErrorMessage] as? String) != nil {
              
                return nil
            }
            
            
            if let savedImage = response[kSavedImage] as? Bool {
                self.savedImage = savedImage
            } else {
                savedImage = false
            }
            
            userExists  = response[kUserExists] as! Bool
            profiles = [User]()

            if userExists {
                
                let usersProfiles  = response[kProfiles] as! [ AnyObject]
                
                for profile in usersProfiles {
                    
                    let username    = profile[kUserName] as! String
                    let acctId      = profile[kAcctId] as! String
                    let guid        = profile[kGuid] as! String
                    
                    let user = User(guid: guid, acctId: acctId, username: username)
                    
                    profiles.append(user)
                }
            }
        } else {
            return nil
        }
    }
    
    
    func hasOneProfile() -> Bool {
        return profiles.count == 1
    }

}