//
//  FriendsResponse.swift
//  PopIn
//
//  Created by Hanny Aly on 8/15/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation

class FriendsResponse {
    
    var friends: [UserUploadFriendModel]
    
    init?(response result: AnyObject?) {
        
        if result == nil {
            return nil
        } else if let response = result as? [String: AnyObject]  {
            
            if (response["ErrorMessage"] as? String) != nil {
                return nil
            }
            
            friends = [UserUploadFriendModel]()
            
            if let allFriends = response["Friends"] as? [ AnyObject ] {
                
                for friend in allFriends {
                    
                    let guid           = friend[kGuid] as! String
                    let username       = friend[kUserName] as! String
                    let fullname       = friend[kFullName] as? String
                    let verified       = friend[kVerified] as? Bool
                    let blocked        = friend[kBlocked] as? Bool
                    
                    let userInfo = UserModel.BasicInfo(guid: guid, username: username, fullname: fullname, verified: verified, blocked: blocked)
                    
                    let userModel = UserUploadFriendModel(withBasic: userInfo, imageType: .Crop)

                    friends.append(userModel)
                }
                
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func hasFriends() -> Bool {
        return friends.count > 0
    }
    
}