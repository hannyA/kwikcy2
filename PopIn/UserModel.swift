//
//  UserModel.swift
//  PopIn
//
//  Created by Hanny Aly on 8/19/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AWSS3
import AWSMobileHubHelper

class UserModel: NSObject {
    
    
    struct BasicInfo {
        var guid    :String
        var username:String
        var fullname:String?
        var verified:Bool?
        var blocked :Bool?
    }
    
    /** Public Buckets */
    
    // case Thumb  = "dromo-profile-thumb"
    // case Crop   = "dromo-profile-crop"
    // case Large  = "dromo-profile-large"
    
    let S3BucketPrefix = "dromo-profile-"
    
    enum ProfileImageType: String {
        case Thumb = "thumb"
        case Crop  = "crop"
        case Large = "large"
    }
    
    
    
    
    //    let downloadManager: HADownloadManager
    
    
    var dictionaryRepresentation: [String: AnyObject]
    let guid: String     // not optional  UserId#AcctId
    let userName: String // not optional
    var fullName: String
    
    var imageS3Key: String
    var about: String?
    var domain: String?
    var friendsCount: Int?
    var verified: Bool?
    var blocked: Bool? // not optional

    
//    var friendStatus: PublicFriendStatus
    //    var userPic: String?
    
    var firstName: String?
    var lastName: String?
    var gender: String?
    var city: String?
    var state: String?
    var country: String?
    var userTestPic: String?
    var userPic: UIImage?
    var userPicURL: NSURL?
    
    var photoCount: Int? // not optional
    var albumCount: Int? // not optional
    var affection: Int?
    var followersCount: Int? // not optional
    var followingCount: Int? // not optional
    var following: Bool? // not optional


    
    var s3BucketType: String {
        return S3BucketPrefix + "\(userImageType.rawValue)"
    }
    
    
    var userImageType: ProfileImageType
    
    var downloadRequest :AWSS3TransferManagerDownloadRequest?

    var avatarImageClosure: ((image: UIImage?) -> ())?

    var downloadFileURL :NSURL? {
        willSet {
            
            print("downloadFileURL setting: \(newValue)")
            if let downloadFileURL = newValue {
                if let data = NSData(contentsOfURL: downloadFileURL) {
                    
                    let image = UIImage(data: data)
                    if let avatarImageClosure = avatarImageClosure {
                        print("setAvatarCellNodeImage: \(newValue)")
                        avatarImageClosure(image: image)
                    }
                }
            } else {
                let failedPlaceHolderImage = UIImage(named: "DefaultProfileImage")
                
                if let avatarImageClosure = avatarImageClosure {
                    print("setAvatarCellNodeImage: \(newValue)")
                    avatarImageClosure(image: failedPlaceHolderImage)
                }
            }
        }
    }
    
    
    
    class func dictionaryRep(info: BasicInfo) -> [String: AnyObject] {
        
        var rep = [String: AnyObject]()
        rep[kGuid]     = info.guid
        rep[kUserName] = info.username
        rep[kFullName] = info.fullname
        rep[kVerified] = info.verified
        return rep
    }
    
    convenience init(withBasic info: BasicInfo, imageType: ProfileImageType) {
        
        let userInfo = UserSearchModel.dictionaryRep(info)
        
        self.init(withUser:userInfo, imageType: imageType)
    }
    
    
    
    
    init(withUser userModel: [String: AnyObject], imageType: ProfileImageType) {
        
        dictionaryRepresentation = userModel
        
        guid     = dictionaryRepresentation[kGuid] as! String
        userName = dictionaryRepresentation[kUserName] as! String
        fullName = dictionaryRepresentation[kFullName] as? String ?? ""
        about    = dictionaryRepresentation[kAbout] as? String
        domain   = dictionaryRepresentation[kDomain] as? String
        verified = dictionaryRepresentation[kVerified] as? Bool
        
        userImageType = imageType
        //        s3BucketType = S3BucketPrefix + "\(userImageType.rawValue)"
        
        imageS3Key = "\(guid)/\(userImageType.rawValue).jpg".stringByAddingPercentEncodingWithAllowedCharacters(.URLUserAllowedCharacterSet())!
        
        print("imageS3Key: \(imageS3Key)")
        
        let newDownloadRequest = AWSS3TransferManagerDownloadRequest()
        
        let downloadingFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("download")
            //            .URLByAppendingPathComponent(userImageType.rawValue)
            .URLByAppendingPathComponent(imageS3Key)
        
        if NSFileManager.defaultManager().fileExistsAtPath(downloadingFileURL.path!) {
            
            downloadRequest = nil
            downloadFileURL = downloadingFileURL
            
        } else {
            
            newDownloadRequest.bucket = S3BucketPrefix + "\(userImageType.rawValue)"
            newDownloadRequest.key    = imageS3Key
            newDownloadRequest.downloadingFileURL = downloadingFileURL
            
            downloadRequest = newDownloadRequest
            downloadFileURL = nil
        }
        
        super.init()
        
    }
}
    