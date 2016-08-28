//
//  Constants.swift
//  PopIn
//
//  Created by Hanny Aly on 5/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation

struct Constants {
    static let TestMode = false
    
    
//    struct Titles: String {
//        var name
//    }
}


let AppName = "Chap Chat"
let iTunesLink = "https://itunes.apple.com/us/app/tinder/id547702041?mt=8"
// "itms-apps://itunes.apple.com/app/id547702041"

// Profile Photo
let kHDVersion:CGFloat = 1080.0
let kSDVersion:CGFloat = 540.0


//NSUserDefaults Keys and Types

let uDataUse = "DataUse" // Bool


let kDictionaryRepresentation = "dictionaryRepresentation"
let kGuid       = "guid"

let kAcctId     = "acctId"
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
let kEmail      = "email"
let kMobile     = "mobile"

let kUserPhoto      = "userPhoto"
let kUserTestPic    = "userTestPic"
let kUserPic        = "userPic"
let kUserPicURL     = "userPicURL"

let kPhotoCount     = "photoCount"
let kAlbumCount     = "albumCount"
let kAffection      = "affection"
let kFriendCount    = "friendCount"
let kFollowersCount = "followersCount"
let kFollowingCount = "followingCount"
let kFollowing      = "following"
let kFriends        = "friends"
let kVerified       = "verified"

let kNotificationId = "id"
let kAlbumId        = "albumId"
let kType           = "type"



let kTitle             = "title";
let kFriendsListAdd    = "friendsToAdd";
let kFriendsListRemove = "friendsToRemove";
let kAction            = "action";


let kMedia      = "media";
let kMediaURL   = "mediaUrl";

let kTimelimit  = "timelimit";
let kAlbumIds   = "albumIds";



let kTimestamp      = "timestamp"
let kDate           = "date"

let kCreateDate      = "createDate"
let kNewestMediaTime = "newestTime"
let kNewestMediaUrl  = "newestUrl"


let kBlocked        = "blocked"



let kDidUpdate      = "DidUpdate"
let kFriendStatus   = "FriendStatus"
let kProfile        = "Profile"
let kProfileExists  = "ProfileExt"


let kSuccess        = "Success"
let kErrorMessage   = "ErrorMessage"



enum AvatarImageCornerRadius:CGFloat {
    case Small = 22.0
    case Medium = 44.0
    case Large = 64.0
}


//let kAvatarCornerRadius: CGFloat = 44.0

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




let randomUpsetEmojis = ["😤","😰","😢","😭","😡","😩","😫","😔"]

func randomUpsetEmoji() -> String {
    return randomUpsetEmojis[Int(arc4random_uniform(UInt32(randomUpsetEmojis.count)))]
}


//class Constants{
//
//    struct Constants {
//        static let someNotification = "TEST"
//    }
//
//    internal let TestMode = true
//}