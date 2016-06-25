//
//  UserModel.swift
//  PopIn
//
//  Created by Hanny Aly on 5/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation

class UserModel: NSObject {
    
//    enum GenderType: Int {
//        case Female = 0
//        case Male = 1
//    }
    
    let dictionaryRepresentation: [String: AnyObject]
    let userId: String? // not optional
    let gender: String?
    let userName: String? // not optional
    let firstName: String?
    let lastName: String?
    let fullName: String?
    let city: String?
    let state: String?
    let country: String?
    let about: String?
    let domain: String?
    
    var userTestPic: String?
    var userPic: UIImage?
    let userPicURL: NSURL?
    
    let photoCount: Int? // not optional
    let albumCount: Int? // not optional
    let affection: Int?
    let friendsCount: Int? // not optional
    let followersCount: Int? // not optional
    let followingCount: Int? // not optional
    let following: Bool? // not optional
    let friends: Bool? // not optional
    
    let verified: Bool? // not optional

    
    init(withUser userModel: [String: AnyObject]) {
        
        dictionaryRepresentation = userModel
        
        userId = dictionaryRepresentation["userId"] as? String
        gender = dictionaryRepresentation["gender"] as? String
        userName = dictionaryRepresentation["userName"] as? String
        firstName = dictionaryRepresentation["firstName"] as? String
        lastName = dictionaryRepresentation["lastName"] as? String
        fullName = dictionaryRepresentation["fullName"] as? String
        city = dictionaryRepresentation["city"] as? String
        state = dictionaryRepresentation["state"] as? String
        country = dictionaryRepresentation["country"] as? String
        about = dictionaryRepresentation["about"] as? String
        domain = dictionaryRepresentation["domain"] as? String
        
        
        if Constants.TestMode {
            
            userTestPic = dictionaryRepresentation["userTestPic"] as? String
            
            if userTestPic != nil {
                userPic = UIImage(named: userTestPic!)
            } else {
                userPic = dictionaryRepresentation["userPic"] as? UIImage
            }
        } else {
            userTestPic = nil
            userPic = dictionaryRepresentation["userPic"] as? UIImage
        }


        userPicURL = dictionaryRepresentation["userPicURL"] as? NSURL
        
        photoCount = dictionaryRepresentation["photoCount"] as? Int
        albumCount = dictionaryRepresentation["albumCount"] as? Int
        affection = dictionaryRepresentation["affection"] as? Int
        friendsCount = dictionaryRepresentation["friendsCount"] as? Int
        followersCount = dictionaryRepresentation["followersCount"] as? Int
        followingCount = dictionaryRepresentation["followingCount"] as? Int
        following = dictionaryRepresentation["following"] as? Bool
        friends = dictionaryRepresentation["friends"] as? Bool
        
        verified = dictionaryRepresentation["verified"] as? Bool
    }
    
    
    func deleteUserPic() {
        userTestPic = nil
        userPic = nil
        
    }
    
    func usernameAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: userName, fontSize: size, color: UIColor.blackColor(), firstWordColor: nil)
    }
    
    func fullNameAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: fullName, fontSize: size, color: UIColor.lightGrayColor(), firstWordColor: nil)
    }
    
}
