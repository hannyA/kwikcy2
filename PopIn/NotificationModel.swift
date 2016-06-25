//
//  NotificationModel.swift
//  PopIn
//
//  Created by Hanny Aly on 6/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

class NotificationModel {
    
    
    enum FriendshipStatus {
        case Nil
        case Friends
        case Pending
        case Blocked
    }
    
    enum NotificationType {
        case Friending
//        case Follow
        case FriendRequest
        case FriendRequestAccepted
    }
    
    let notifications:[NotificationType] = [.Friending, .FriendRequest, .FriendRequestAccepted]

    
    var user: UserModel

    var notificationType : NotificationType
    
    var timeStamp: String
    var message: String

    var friendshipStatus: FriendshipStatus
    
    
    init(fromUser user: UserModel) {
        
        
        let randomNotif = notifications[Int(arc4random_uniform(UInt32(notifications.count)))]
        
        self.user = user
        notificationType = randomNotif
        
        timeStamp = " ·2w"
        message = user.userName!
        
        switch randomNotif {
            case .Friending:
                friendshipStatus = .Pending
            case .FriendRequest:
                friendshipStatus = .Nil
            case .FriendRequestAccepted:
                friendshipStatus = .Friends
        }
        
        
        if notificationType == .Friending {
            message = "Sent a friend request to \(user.userName!)"
        } else if notificationType == .FriendRequestAccepted {
            message += " and you are now friends"
        } else if notificationType == .FriendRequest {
            message += " wants to be friends"
        }
        else {
            message += " is following you"
        }
    }
    

    

}