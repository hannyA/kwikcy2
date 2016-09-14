//
//  NotificationModel.swift
//  PopIn
//
//  Created by Hanny Aly on 6/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AWSS3
import AWSMobileHubHelper
import ChameleonFramework
import SwiftIconFont

protocol HANotificationModelDelegate {
    
    // Notify the cellnode of any change that happened from UserProfilePageVC
    func didChangeFriendStatus()
}

class HANotificationModel {
    
    
    /*
     *  We don't need a separate lambda function.
     *  DRFriendAction already deals with these functions.
     *
     *  FRIENDS, ACCEPT, BLOCK, UNBLOCK, CANCEL
     */
    
    
//    let FRIENDS = "F"
//    let ACCEPT  = "A"
//    let CANCEL  = "C"
//    let BLOCK   = "B"
//    let UNBLOCK = "U"
//    let DELETE  = "D"
//    
    
//    // Actions
//    enum AWSLambdaFriendAction: String {
//        case Friends = "F"
//        case Accept = "A"
//        case Cancel = "C"
//        case Block = "B"
//        case Unblock = "U"
//        
//        func description() -> String {
//            return self.rawValue
//        }
//    }

    
    
    enum NotificationResponseActionType: String {
        // IF sent, we can canel
        case Cancel                 = "C"  // -> CANCEL
        // If received, we can accept or block user
        case AcceptFriendRequest    = "A"    // -> ACCEPT
//        case IgnoreUser             // -> BLOCK????
        case BlockUser              = "B"    // -> BLOCK????
        // If we accept, we can later block user
        case UnBlockUser            = "U"    // -> BLOCK????
        // If other person accepted, we could block or delete notification?
//        case DeleteNotification     = "D"   // Just deletes the notification from the DB
    }
    
    
    enum NotificationType: String {
        case SentFriendRequest      = "SFR"
        case ReceivedFriendRequest  = "RFR"
        case FriendAcceptedRequest  = "RFRA"
        case FriendRequestCanceled  = "FRC"
//        case Follow
//        case Blocked
//        case Blocking               = "B"
    }
    
    
    var otherUser: UserSearchModel
    
    var id: Int
    var type: NotificationType
    var timeStamp: String
    
    var date: NSDate

    init?(item: AnyObject) {
        
        let notificationDictionary = item as! [String: AnyObject]
        
        var user = [String: AnyObject]()
        
        user[kGuid]     = notificationDictionary[kGuid]     as! String
        user[kVerified] = notificationDictionary[kVerified] as! Bool
        user[kUserName] = notificationDictionary[kUserName] as! String
        user[kFullName] = notificationDictionary[kFullName] as? String
        user[kAbout]    = notificationDictionary[kAbout]    as? String
        user[kDomain]   = notificationDictionary[kDomain]   as? String
        user[kFriendStatus] = notificationDictionary[kFriendStatus] as? String
        user[kFriendCount]  = notificationDictionary[kFriendCount]  as? Int
        
        
        otherUser = UserSearchModel(withUser: user, imageType: .Crop)
        
        print("otherUser.friendstatus in notif: \(otherUser.friendStatus)")
        let notifType = HANotificationModel.notifType(notificationDictionary[kType] as! String)
        
        print("notifType \(notifType)")

        if notifType == nil {
            return nil
        }
     
        type = notifType!
        
        if let time = notificationDictionary[kTimestamp] as? String {
            print("kTimestamp: \(time)")
            timeStamp   = time
        } else {
            timeStamp = notificationDictionary[kDate] as! String
        }
        
        if let aDate = notificationDictionary[kDate] as? String {
            print("kDate: \(aDate)")
        }
        
        
        let inputDate = notificationDictionary[kDate] as! String
        
        date = NSDate().fromTimestamp(inputDate)

        id = notificationDictionary[kNotificationId] as! Int
    }
    
    
    class func notifType(type: String) -> NotificationType? {
        
        switch type {
        case NotificationType.SentFriendRequest.rawValue :
            return .SentFriendRequest
        case NotificationType.ReceivedFriendRequest.rawValue:
            return .ReceivedFriendRequest
        case NotificationType.FriendAcceptedRequest.rawValue:
            return .FriendAcceptedRequest
        case NotificationType.FriendRequestCanceled.rawValue:
            return .FriendRequestCanceled
        default:
            return nil
        }
    }
    
    
//    func timeAgo() -> String {
//        
//        if timeStamp.characters.count == 13 {
//            
//        }
//
//        let notificationTimeStampInterval : NSTimeInterval = Double(timeStamp)!/1000 //(timeStamp as NSString).doubleValue/1000
//        
//        let nowTimeInterval = NSDate().timeIntervalSince1970
//        
//        
//        let secondsAgo = Int(nowTimeInterval - notificationTimeStampInterval)
//        
//        print("secondsAgo: \(secondsAgo)")
//        
//        var time: String
//        if minutes(secondsAgo) == 0 {
//            time = "\(secondsAgo)s"
//        } else if minutes(secondsAgo) < 60 {
//            time = "\(minutes(secondsAgo))m"
//
//        } else if hours(minutes(secondsAgo)) < 24 {
//            time = "\(hours(minutes(secondsAgo)))h"
//        } else  {
//            time = "\(days(hours(minutes(secondsAgo))))d"
//        }
//        
//        return time
//    }
//    
//    
//    
//    func minutes(seconds: Int) -> Int {
//        return seconds / 60
//    }
//    
//    func hours(minutes: Int) -> Int {
//        return minutes / 60
//    }
//    
//    func days(hours: Int) -> Int {
//        return hours / 24
//    }
//    
    
//    func imageForNotificationType() -> (image: UIImage, itsColor: UIColor, borderColor: UIColor, borderWidth: CGFloat) {
    
    func imageForNotificationType() -> (title: NSAttributedString?, image: UIImage?, backgroundImage: UIImage?,  backgroundColor: UIColor, borderColor: UIColor) {
        
        switch type {
            
        case .ReceivedFriendRequest:
            
            if otherUser.friendStatus == .Friends {
                
                let imageColor      = UIColor.flatWhiteColor()
                let backgroundColor = UIColor.flatGreenColor()
                let borderColor     = UIColor.clearColor()

                let titleImage = NSAttributedString.titleNodeIcon(from: .MaterialIcon,
                                                                  code: "person",
                                                                  ofSize: 35,
                                                                  color: imageColor)
                let image = UIImage.icon(from: .MaterialIcon,
                                         code: "check",
                                         imageSize: CGSizeMake(10, 10),
                                         ofSize: 10,
                                         color: imageColor)
              
                return (titleImage, image, nil, backgroundColor, borderColor)

            } else {
                // Did nothing with friend request
                
                
                let imageColor      = UIColor.flatBlackColor()
                let borderColor     = UIColor.flatBlackColor()
                let backgroundColor = UIColor.flatWhiteColor()

                let image = UIImage.icon(from: .MaterialIcon,
                                         code: "person.add",
                                         imageSize: CGSizeMake(30, 30),
                                         ofSize: 30,
                                         color: imageColor)
                
                return (nil, image, nil, backgroundColor, borderColor)
            }
            
        case .SentFriendRequest:
            
            if otherUser.friendStatus == .Friends {
                
                let imageColor = UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1.0)
                let backgroundColor = UIColor.flatWhiteColor()
                let borderColor = UIColor.clearColor()
               
                let image = UIImage.icon(from: .MaterialIcon,
                                         code: "favorite",
                                         imageSize: CGSizeMake(30, 30),
                                         ofSize: 30,
                                         color: imageColor)

                return (nil, image, nil, backgroundColor, borderColor)


            } else {
                
                let imageColor      = UIColor.flatRedColor()
                let backgroundColor = UIColor.flatWhiteColor()
                let borderColor     = UIColor.flatRedColor()
                
                let image = UIImage.icon(from: .MaterialIcon,
                                         code: "do.not.disturb.on", //  chnages to do.not.disturb.on
                                         imageSize: CGSizeMake(30, 30),
                                         ofSize: 30,
                                         color: imageColor)
                
                return (nil, image, nil, backgroundColor, borderColor)
            }
            

        case .FriendAcceptedRequest:
            
            let imageColor = UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1.0)
            let backgroundColor = UIColor.flatWhiteColor()
            let borderColor = UIColor.clearColor()
            
            let image = UIImage.icon(from: .MaterialIcon,
                                     code: "favorite",
                                     imageSize: CGSizeMake(30, 30),
                                     ofSize: 30,
                                     color: imageColor)
            
            return (nil, image, nil, backgroundColor, borderColor)
        
        default:
            let imageColor = UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1.0)
            let backgroundColor = UIColor.flatWhiteColor()
            let borderColor = UIColor.clearColor()
            
            let image = UIImage.icon(from: .MaterialIcon,
                                     code: "favorite",
                                     imageSize: CGSizeMake(30, 30),
                                     ofSize: 30,
                                     color: imageColor)
            
            return (nil, image, nil, backgroundColor, borderColor)
            
        }
    }
    
 
    
    
    
    
    
    func attributedMessageString() -> NSAttributedString {
        
        let usernameBold = NSMutableAttributedString(string: otherUser.userName,
                                                     attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                                        NSFontAttributeName: UIFont(name: kAppMainFontBold, size: kTextSizeXXS)!])
        
        let fullMessageTime = NSMutableAttributedString()
        
        switch type {
        case .SentFriendRequest:
            
            let attrMessage = HAGlobal.titlesAttributedString("Sent friend request to ",
                                                              color: UIColor.blackColor(),
                                                              textSize: kTextSizeXXS)
            fullMessageTime.appendAttributedString(attrMessage)
            fullMessageTime.appendAttributedString(usernameBold)
            
        case .ReceivedFriendRequest:
            
            let attrMessage = HAGlobal.titlesAttributedString(" sent you a friend request",
                                                              color: UIColor.blackColor(),
                                                              textSize: kTextSizeXXS)
            fullMessageTime.appendAttributedString(usernameBold)
            fullMessageTime.appendAttributedString(attrMessage)
            
        case .FriendAcceptedRequest:
            
            let attrMessage = HAGlobal.titlesAttributedString(" accepted your friend request",
                                                              color: UIColor.blackColor(),
                                                              textSize: kTextSizeXXS)
            fullMessageTime.appendAttributedString(usernameBold)
            fullMessageTime.appendAttributedString(attrMessage)
        
        
        default:
            
            let attrMessage = HAGlobal.titlesAttributedString(" accepted your friend request",
                                                              color: UIColor.blackColor(),
                                                              textSize: kTextSizeXXS)
            fullMessageTime.appendAttributedString(usernameBold)
            fullMessageTime.appendAttributedString(attrMessage)
            
        }
        
        let attributedDot = NSAttributedString(string: " · ",
                                               attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
                                                NSFontAttributeName: UIFont(name: kAppMainFontBold,
                                                    size: kTextSizeXS)!])
        
        
        fullMessageTime.appendAttributedString(attributedDot)
        
        let attributedTimestamp = HAGlobal.titlesAttributedString( NSDate().timeAgoFromDate(date),
                                                                  color: UIColor.lightGrayColor(),
                                                                  textSize: kTextSizeXXS)
        
        fullMessageTime.appendAttributedString(attributedTimestamp)
        
        return fullMessageTime
    }
}



