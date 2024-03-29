//
//  AWSConstants.swift
//  PopIn
//
//  Created by Hanny Aly on 7/9/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

//class DromoIdentityManager {
//    



// Login/Registration
let AWSLambdaLogin            = "DromoLogin"    //"HALogin"
let AWSLambdaRegister         = "DromoRegisterUser" //"HA_Register_With_Locks"
let AWSLambdaValidateUsername = "DromoValidateUsername" //"DRValidateUsername"

// App
let AWSLambdaAccountActive    = "DromoAccountIsActive"
let AWSLambdaDromoAppUptoDate = "DromoAppUptoDate"


// Search
let AWSLambdaSearchUsers      = "DromoSearchUsers" //"HASearchUsers"


let AWSLambdaNotifications    = "DromoNotifications"
let AWSLambdaGetUsersProfile  = "DromoUserProfile"

// Friends stuff
let AWSLambdaSocialAction     = "DromoFriendAction"
let AWSLambdaUserFriends      = "DromoUserFriends" // Gets a list of user friends
let AWSLambdaFriendsAlbums    = "DromoAlbumsOfFriends" // List of friends albums


// Users album
let AWSLambdaMyAlbums         = "DromoUserAlbums" // List of my albums

let AWSLambdaOpenAlbum        = "DromoAlbumOpen" // Open/Get media content
let AWSLambdaCreateAlbum      = "DromoCreateAlbum"
let AWSLambdaDeleteAlbum      = "DromoDeleteAlbum"

let AWSLambdaUpdateAlbum      = "DromoUpdateAlbum" // Edit title, users,
//let AWSLambdaAddAlbumFriend   = "DromoAddAlbumFriend"

let AWSLambdaUploadMedia      = "DromoMediaUpload" // Uploads media to mulitple albums

//Settings

let AWSLambdaUpdateProfile      = "DromoUpdateProfile"

let AWSLambdaFacebookVerify     = "DromoFacebookVerification"
let AWSLambdaDeleteAccount      = "DromoUserDeleteAccount"

let AWSLambdaUpdatePushNotificationSettings   = "DromoUpdatePushNotificationSettings"
let AWSLambdaFeedback                         = "DromoFeedback"




let AWSErrorBackend = "\(AppName) is experiencing problems. Try again shortly."
//let AWSErrorNetwork = "Network error. Try again shortly."


class AWSConstants {
    
    
    class func errorMessage(error: NSError?) -> String? {
        
        if let error = error {

            var errorMessage: String
            if let cloudUserInfo = error.userInfo as? [String: AnyObject],
                cloudMessage = cloudUserInfo["errorMessage"] as? String {
                errorMessage = "\(cloudMessage)"
                
                print("CloudMessage: \(errorMessage)")
            }
            
            errorMessage = AWSErrorBackend
            return errorMessage
        }
        return nil
    }
}