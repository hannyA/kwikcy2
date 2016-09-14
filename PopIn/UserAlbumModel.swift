//
//  UserAlbumModel.swift
//  PopIn
//
//  Created by Hanny Aly on 8/31/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AWSMobileHubHelper



struct UserAlbum {
    var albumId    :String
    var title      :String
    var date       :NSDate
    var newestTime :NSDate
    var newestUrl  :String?
    var mediaCount :Int
}




class UserAlbumModel: AlbumModel {
    
    var acl: [String]?

    
    var newestMediaUrl: String?
    var newestMediaTime: NSDate?
    

    var lastUploadSuccessful = true
    
    var lastUploadedMediaObject: String? // Maybe this should be a local URL
    var lastUploadedType       : String?
    var lastUploadedTimelimit  : Int?
   
    
    
    
    // Getting a list of albums, either ours or friends
    override init(withAlbum album: UserAlbum) {
        
        super.init(withAlbum: album)
    }
    
    
    // TOdo Delte
    // For creating new albums
    init(withTitle title: String, usersAccessControlList usersGuids: [String]) {
        
        super.init(id: "", title: title, date: NSDate(), count: 0)

        self.acl = usersGuids
        
        //
        //        let realmAlbum = Album()
        //        realmAlbum.title = title
        //        realmAlbum.acl.appendContentsOf(userList(acl!))
        //        let realm = try! Realm()
        //        try! realm.write() {
        //            realm.create(Album.self, value: realmAlbum, update: false)
        //
        //            //            (Album.self, value: ["Jane", 27])
        //            //            // Reading from or modifying a `RealmOptional` is done via the `value` property
        //            //            person.age.value = 28
        //        }
        
    }
    
    func createAlbum(onCompletion closure: (successful :Bool) ->() ){
        
        isUploading = true
        
        var jsonObj = [String: AnyObject]()
        if let title = title {
            jsonObj[ "title"] = title
        }
        
        jsonObj["friends"] = acl
        
        
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaCreateAlbum,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            self.isUploading = false
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    print("CloudLogicViewController: Result: \(result)")
                    
                    if let objectAsDictionary = result as? [String: AnyObject] {
                        
                        let success = objectAsDictionary["Success"] as! Bool
                        let albumId = objectAsDictionary[kAlbumId] as? String
                        
                        if success {
                            self.id = albumId
                            closure(successful: true)
                        } else {
                            closure(successful: false)
                        }
                    } else {
                        closure(successful: false)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                dispatch_async(dispatch_get_main_queue(), {
                    closure(successful: false)
                })
            }
        }
    }
    

    
    func retryUploadingLastMedia(onCompletion closure: (successful :Bool, errorMessage: String?) ->() ){
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]      = Me.sharedInstance.guid()
        jsonObj[kAcctId]    = Me.sharedInstance.acctId()
        
        jsonObj[kMedia]     = lastUploadedMediaObject
        jsonObj[kType]      = lastUploadedType
        jsonObj[kTimelimit] = lastUploadedTimelimit
        jsonObj[kAlbumIds]  = [id!]
        
        isUploading = true
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaUploadMedia,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            self.isUploading = false
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("uploadMedia: CloudLogicViewController: Result: \(result)")
                    
                    if let response = result as? [String: AnyObject]  {
                        
                        let successful   = response[kSuccess] as! Bool
                        let errorMessage = response[kErrorMessage] as? String
                        
                        closure(successful: successful, errorMessage: errorMessage)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                print("uploadMedia: failed")
                
                dispatch_async(dispatch_get_main_queue(), {
                    closure(successful: false, errorMessage: AWSErrorBackend)
                    
                })
            }
        }
    }
    
    
    
    
    
    func updateACL(acl: [String], onCompletion closure: (successful :Bool) ->() ){
        
        isUploading = true
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]    = Me.sharedInstance.guid()
        jsonObj["friends"] = acl
        jsonObj[ "id"]    = id
        
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaUpdateAlbum,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            self.isUploading = false
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    print("CloudLogicViewController: Result: \(result)")
                    
                    if let objectAsDictionary = result as? [String: AnyObject] {
                        
                        let success = objectAsDictionary[kSuccess] as! Bool
                        let albumId = objectAsDictionary[kAlbumId] as? String
                        
                        if success {
                            self.id = albumId
                            closure(successful: true)
                        } else {
                            closure(successful: false)
                        }
                    } else {
                        closure(successful: false)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                dispatch_async(dispatch_get_main_queue(), {
                    closure(successful: false)
                })
            }
        }
    }
    
    
    
    func updateTitle(title: String, onCompletion closure: (successful :Bool) ->() ){
        
        isUploading = true
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]     = Me.sharedInstance.guid()
        jsonObj[kAction]   = "Title"
        jsonObj[kAlbumId]  = id
        jsonObj[kTitle]    = title
        
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaUpdateAlbum,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            self.isUploading = false
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if let objectAsDictionary = result as? [String: AnyObject] {
                        
                        let success = objectAsDictionary["Success"] as! Bool
                        
                        if success {
                            self.title = title
                            closure(successful: true)
                        } else {
                            closure(successful: false)
                        }
                    } else {
                        closure(successful: false)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                dispatch_async(dispatch_get_main_queue(), {
                    closure(successful: false)
                })
            }
        }
    }
    
    
    func timeAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
        
        
        if let newestMediaTime = newestMediaTime {
            let timeago = NSDate().timeAgoFromDate(newestMediaTime)
            
            return NSAttributedString(string: timeago,
                                      fontSize: size,
                                      color: UIColor.lightGrayColor(),
                                      firstWordColor: nil)
        }
        return NSAttributedString()
    }
    
    
    
}