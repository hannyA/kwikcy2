//
//  Constants.swift
//  PopIn
//
//  Created by Hanny Aly on 5/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation

struct Constants {
    static let TestMode = true
    
    
//    struct Titles: String {
//        var name
//    }
}


let kDictionaryRepresentation = "dictionaryRepresentation"
let kUserId     = "userId"
let kGender     = "gender"
let kUserName   = "userName"
let kFirstName  = "firstName"
let kLastName   = "lastName"
let kFullName   = "fullName"
let kCity       = "city"
let kState      = "state"
let kCountry    = "country"
let kAbout      = "about"
let kDomain     = "domain"

let kUserTestPic    = "userTestPic"
let kUserPic        = "userPic"
let kUserPicURL     = "userPicURL"

let kPhotoCount     = "photoCount"
let kAlbumCount     = "albumCount"
let kAffection      = "affection"
let kFriendsCount   = "friendsCount"
let kFollowersCount = "followersCount"
let kFollowingCount = "followingCount"
let kFollowing      = "following"
let kFriends        = "friends"
let kVerified       = "verified"




// Images

let kRightArrowHead = "connect-arrow-right-7"




enum AvatarImageCornerRadius:CGFloat {
    case Small = 22.0
    case Medium = 44.0
    case Large = 64.0
}

let AppName = "Popin"

let kAvatarCornerRadius: CGFloat = 44.0

let kTextSizeXXS: CGFloat     = 15.0
let kTextSizeXS: CGFloat      = 16.0
let kTextSizeSmall: CGFloat   = 18.0
let kTextSizeRegular: CGFloat = 20.0
let kTextSizeLarge: CGFloat   = 22.0
let kTextSizeXL: CGFloat      = 24.0


let kAppMainFont = "HelveticaNeue"
let kAppMainFontBold = "HelveticaNeue-Bold"


let kWebResponseDelayVeryFast: UInt64 = 1
let kWebResponseDelayFast: UInt64 = 2
let kWebResponseDelay: UInt64 = 3
let kWebResponseDelaySlow: UInt64 = 5
let kWebResponseDelayVerySlow: UInt64 = 10

enum AttributeColor {
    case WhiteTextDarkBackground
    case BlackTextLightBackground
    case LightGrayTextDarkBackground
}


func pageTitlesAttributedString(string: String, forState state: UIControlState) -> NSAttributedString {
    
    switch state {
    case UIControlState.Normal:
        let lightGray = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.7)
        return NSAttributedString(string: string,
                                  attributes: [NSForegroundColorAttributeName: lightGray,
                                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: kTextSizeRegular)!])
    case UIControlState.Highlighted:
        return NSAttributedString(string: string,
                                  attributes: [NSForegroundColorAttributeName: UIColor.blueColor(),
                                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: kTextSizeRegular)!])
        
    case UIControlState.Selected:
        return NSAttributedString(string: string,
                                  attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: kTextSizeRegular)!])
    default:
        return NSAttributedString(string: string,
                                  attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: kTextSizeRegular)!])
    }
}



//class Constants{
//
//    struct Constants {
//        static let someNotification = "TEST"
//    }
//
//    internal let TestMode = true
//}