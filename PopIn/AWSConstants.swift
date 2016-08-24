//
//  AWSConstants.swift
//  PopIn
//
//  Created by Hanny Aly on 7/9/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

//class DromoIdentityManager {
//    


let AWSLambdaLogin            = "DromoLogin"    //"HALogin"
let AWSLambdaRegister         = "DromoRegisterUser" //"HA_Register_With_Locks"
let AWSLambdaValidateUsername = "DromoValidateUsername" //"DRValidateUsername"
let AWSLambdaSearchUsers      = "DromoSearchUsers" //"HASearchUsers"


let AWSLambdaNotifications    = "DromoNotifications" //"HASearchUsers"
let AWSLambdaGetUsersProfile  = "DromoUserProfile" //"HASearchUsers"
let AWSLambdaSocialAction     = "DromoFriendAction" //"HASearchUsers"

let AWSLambdaUserFriends      = "DromoUserFriends"

let AWSLambdaMyAlbums         = "DromoUserAlbums" //"HASearchUsers"
let AWSLambdaFriendsAlbums    = "DromoFriendsAlbums"

let AWSLambdaCreateAlbum      = "DromoCreateAlbum"
let AWSLambdaDeleteAlbum      = "DromoDeleteAlbum"

let AWSLambdaUpdateAlbum      = "DromoUpdateAlbum"
let AWSLambdaAddAlbumFriend   = "DromoAddAlbumFriend"
let AWSLambdaUploadMedia      = "DromoUploadMedia"


let AWSLambdaUpdateProfile      = "DromoUpdateProfile"




let AWSErrorBackend = "\(AppName) is experiencing problems. Try again shortly."
let AWSErrorNetwork = "Network error. Try again shortly."


class AWSConstants {
    
    
    class func errorMessage(error: NSError?) -> String? {
        
        if let error = error {

            var errorMessage: String
            if let cloudUserInfo = error.userInfo as? [String: AnyObject],
                cloudMessage = cloudUserInfo["errorMessage"] as? String {
                errorMessage = "\(cloudMessage)"
            }
            
            errorMessage = AWSErrorBackend
            return errorMessage
        }
        return nil
    }
}