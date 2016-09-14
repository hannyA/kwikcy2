//
//  UserSearchModel.swift
//  PopIn
//
//  Created by Hanny Aly on 7/10/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AWSS3
import AWSMobileHubHelper
import RealmSwift


protocol UserSearchModelDelegate {
    func didUpdateFriendStatus()
}

class UserSearchModel: UserModel {
    
    var delegate: UserSearchModelDelegate?  // For HANotification CellNode
    
    // Actions
    enum AWSLambdaFriendAction: String {
        case Friends    = "F"
        case Accept     = "A"
        case Cancel     = "C"
        case Block      = "B"
        case Unblock    = "U"

        func description() -> String {
            return self.rawValue
        }
    }
    
    enum PublicFriendStatus: String {
        case Unknown                = "U"
        case NoneExist              = "NE"
        
        case SentFriendRequest      = "SFR"
        case ReceivedFriendRequest  = "RFR"
        case Friends                = "F"
        case Blocking               = "B"
        
        static let allValues = [Unknown, NoneExist, SentFriendRequest, ReceivedFriendRequest, Friends, Blocking]
  
    }
    
    
    
    var friendStatus: PublicFriendStatus
    
    convenience init(withBasic info: BasicInfo, imageType: ProfileImageType) {
        
        let userInfo = UserModel.dictionaryRep(info)
        
        self.init(withUser: userInfo, imageType: imageType)
    }
    
    
    
    
    override init(withUser userInfo: [String: AnyObject], imageType: ProfileImageType) {
        
        friendStatus = .Unknown
        
        super.init(withUser: userInfo, imageType: imageType)
        
        if let status = dictionaryRepresentation[kFriendStatus] as? String {
            updateFriendStatus( friendshipStatus( status))
        }
    }

    
    func updateFriendStatus(status: PublicFriendStatus) {
        friendStatus = status
        if let delegate = delegate {
            delegate.didUpdateFriendStatus()
        }
    }
    
        
    func friendshipStatus(status: String) -> PublicFriendStatus {
        
        for possibleStatus in PublicFriendStatus.allValues{
            
            if status == possibleStatus.rawValue {
                return possibleStatus
            }
        }
        return .Unknown
    }

    
    
    func actionToTake() -> String? {
        
        if friendStatus == .SentFriendRequest {
            return AWSLambdaFriendAction.Cancel.rawValue
            
        } else if friendStatus == .ReceivedFriendRequest {
            return AWSLambdaFriendAction.Accept.rawValue
            
        } else if friendStatus == .Friends {
            return AWSLambdaFriendAction.Block.rawValue
            
        } else if friendStatus == .Blocking {
            return AWSLambdaFriendAction.Unblock.rawValue
            
        } else if friendStatus == .NoneExist {
            return AWSLambdaFriendAction.Friends.rawValue
        }
        else { // UNKNOWN ...
            return nil
        }
    }
    
//    
//      "Action"          : action,
//      "FriendGuid"
//    
//    
// "NotificationId" : notificationId,
// "FriendGuid"
    
    
    
    
    func lambdaNotificationAction(action: String, notificationId: Int, completionClosure: (successful :Bool, errorMessage: String?, friendStatus: PublicFriendStatus) ->()) {
        
        
        let jsonInput:[String: AnyObject] = [kAcctId         : Me.sharedInstance.acctId()!,
                                             kAction         : action,
                                             kNotificationId : notificationId,
                                             kFriendGuid     : guid]
        
        print("lambdaNotificationAction calling lambdaChangeFriendStatus \(jsonInput)")
        
        lambdaChangeFriendStatus(jsonInput, completionClosure: completionClosure)
    }
    
    
    

    
    
    func changeFriendshipStatus(completionClosure: (success:Bool, errorMessage:String?, newStatus :PublicFriendStatus) ->()) {
        
        print("changeFriendshipStatus")
        if let action = actionToTake() {
            
            print("action: \(action)")
            
            let jsonInput:[String: String] = [kAcctId     : Me.sharedInstance.acctId()!,
                                              kAction     : action,
                                              kFriendGuid : guid]
            
            lambdaChangeFriendStatus(jsonInput, completionClosure: completionClosure)
        }
    }
    
    
    
    func lambdaChangeFriendStatus(parameters: [String: AnyObject], completionClosure: (successful :Bool, errorMessage: String?, friendStatus: PublicFriendStatus) ->()) {
        
        
        print("lambdaNotificationAction called")
        
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaSocialAction,
         withParameters: parameters) { (result: AnyObject?, error: NSError?) in
            
            
            print("Returned DRFriendAction: Result: \(result)")
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("UserSearch CloudLogicViewController: Result: \(result)")
                    
                    let (didUpdateFriendStatus, errorMessage) = self.updateFriendStatus(result)
                    
                    

//                    // Get the default Realm
//                    let realm = try! Realm()
//                    // You only need to do this once (per thread)
//                    
//                    let friend = RealmFriend()
//                    friend.userName = self.userName
//                    friend.guid = self.guid
//                    if let url = self.downloadFileURL {
//                        friend.picture =  NSData(contentsOfURL: url)
//                    }
//                    
                    
//                    let realmFriend = realm.create(<#T##type: T.Type##T.Type#>, value: <#T##AnyObject#>, update: <#T##Bool#>)
                    
//                    
//                    let realmFriend = realm.create(RealmFriend.self, value: friend)//, update: true)
//                    
//                    // Add to the Realm inside a transaction
//                    try! realm.write {
//                        realm.add(realmFriend)
//                    }
                    
                    
                    
                    
                    
                    
                    completionClosure(successful: didUpdateFriendStatus,
                                    errorMessage: errorMessage,
                                    friendStatus: self.friendStatus)
                    
                })
            }
            
            if let errorMsg = AWSConstants.errorMessage(error) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    print("Error occurred in invoking Lambda Function: \(error)")
                    print("Error occurred in invoking Lambda Function: \(errorMsg)")
                    completionClosure(successful: false,
                                    errorMessage: nil,
                                    friendStatus: self.friendStatus)
                })
            }
        }
    }


    //MARK: AWS Lambda
    
    /*
     * Returns a user's profile for their full profile view
     */
    
    
    func queryLambdaUserInfo(completionClosure: (success :Bool) ->()) {
        
//        profileImageType(.Large)
    
        // Download user's larger photo
//        if let downloadRequest = downloadRequest  {
//            download(downloadRequest)
//        }
        
        let parameters = [kFriendGuid: guid,
                          kAcctId    : Me.sharedInstance.acctId()!]
        

        
        //        HAUserProfileBasic
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaGetUsersProfile,
         withParameters: parameters) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("queryLambdaUserInfo CloudLogicViewController: Result: \(result)")
                    
                    let didGetUserDetails = self.updateUserDetails(result)
                    
                    completionClosure(success: didGetUserDetails)
                })
            }
            

            if let errorMsg = AWSConstants.errorMessage(error) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    print("Error occurred in invoking Lambda Function: \(error)")
                    print("Error occurred in invoking Lambda Function: \(errorMsg)")
                    
                    completionClosure(success: false)
                })
            }
        }
    }
    
 
    
    // Functions to update user model
    
    func updateUserDetails(object: AnyObject?) -> Bool {
        
        print("updateUserDetails \(object)")
        if let objectAsDictionary = object as? [String: AnyObject] {
        
            if let userFound = objectAsDictionary[kProfileExists] as? Bool {
                    
                let profile = objectAsDictionary[kProfile] as! [ String: AnyObject] // Array of dictionaries
                updateInfo(profile)
                
                let friendStatusText = objectAsDictionary[kFriendStatus] as! String
                friendStatus = friendshipStatus(friendStatusText)
                
                return userFound
            }
        }
        return false
    }
    
    
    
    func updateInfo(info: [String: AnyObject]) {
        
        print("updateInfo info: \(info)")
        
        for (key, object) in info {
            if let objectAsString = object as? String {
                
                dictionaryRepresentation[key] = objectAsString
                
                if key == kAbout {
                    about = objectAsString
                }
                if key == kDomain {
                    domain = objectAsString
                }
                if key == kFriendStatus {
                    friendStatus = friendshipStatus(objectAsString)
                }
            }
        }
    }
    
    
    
    
    
    func updateFriendStatus(object: AnyObject?) -> (Bool, String?) {
        
        print("updateFriendStatus")
        
        if let objectAsDictionary = object as? [String: AnyObject] {
            
            
            let didUpdate    = objectAsDictionary[kDidUpdate]    as? Bool
            let errorMessage = objectAsDictionary[kErrorMessage] as? String
            
            
            if let didUpdate = didUpdate {
                
                if didUpdate {
                    
                    let friendStatus = objectAsDictionary[kFriendStatus] as! String
                    
                    updateFriendStatus(friendshipStatus(friendStatus))
                    return (didUpdate, nil)
                    
                } else if let errorMessage = errorMessage {
                    
                    return (false, errorMessage)

                } else {
                    return (false, nil)
                }
            } else {
                return (false, AWSErrorBackend)
            }
//            if let didUpdate = objectAsDictionary[kDidUpdate] as? Bool {
//                
//                if didUpdate {
//                    
//                    let status = objectAsDictionary[kFriendStatus] as! String
//                    
//                    updateFriendStatus(friendshipStatus(status))
//                    return (didUpdate, nil)
//                
//                } else {
//                    let errorMessage = objectAsDictionary["Message"] as! String
//                    return (false, errorMessage)
//                }
//            } else {
//                return (false, nil)
//            }
        }
        return (false, AWSErrorBackend)
    }

    
}
    