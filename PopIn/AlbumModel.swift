//
//  AlbumDetails.swift
//  PopIn
//
//  Created by Hanny Aly on 5/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



//protocol AlbumModelDelegate {
//    func uploadAlbum(album: AlbumModel, completeWithSuccess completed: Bool)
//}

import AWSMobileHubHelper

class AlbumModel {
    
    var dictionaryRepresentation: [String: AnyObject]

    var id: Int?
    var title: String?
    var ownerProfile: UserModel?
    
    var coverPhoto: String?
    var coverPhotoURL: NSURL?
    var coverPhotoImage: UIImage?
    var coverPhotoData: NSData?
    
    var createDate: String?
    var newestMediaUrl: String?
    var newMediaTime: String?
    
    
    var uploadDateRaw: String?
    var uploadDateString: String?
    var time: String? // last photo update time
   
    
    var urlString: String?
    var URL: NSURL? // urlString ? [NSURL URLWithString:urlString] : nil;
    
    var mediaCount: Int?
    
    var mediaContent = [MediaModel]()  //later urls? or NSData
    
    var hasNewContent: Bool
    
    var currentItemIndex = 0
    var newMediaIndex: Int?
    
    var isUploading = false
    
    var acl: [String]?
    
    
    
    
    
    // For creating new albums
    init(withTitle title: String, usersAccessControlList usersGuids: [String]) {
        
        self.title = title
        self.acl = usersGuids
        mediaCount = 0
        
        dictionaryRepresentation = [String: AnyObject]()
        dictionaryRepresentation["title"] = self.title
//        mediaContent = [MediaModel]()
        hasNewContent = false
    }
    
    
    
    // Getting a list of albums, either ours or friends
    init(withAlbum album: AlbumResponse.Album) {
        
        
        title = album.title
        id = album.albumId
        createDate  = album.date
        newestMediaUrl = album.newestUrl
        newMediaTime = album.newestTime
        
        dictionaryRepresentation = [String: AnyObject]()
        dictionaryRepresentation["title"] = album.title
        dictionaryRepresentation["id"] = album.albumId
        dictionaryRepresentation["title"] = album.date
        dictionaryRepresentation["time"] = album.newestTime
        dictionaryRepresentation["coverPhoto"] = album.newestUrl

        hasNewContent = false
        
//        mediaContent = dictionaryRepresentation["mediaContent"] as? [MediaModel]
//        hasNewContent = dictionaryRepresentation["hasNewContent"] as! Bool
//        newMediaIndex = dictionaryRepresentation["newMediaIndex"] as? Int
    }

    init(withAlbumInfo info: [String: AnyObject]) {
       
        dictionaryRepresentation = info
        hasNewContent = false
//        mediaContent = dictionaryRepresentation["mediaContent"] as! [MediaModel]
//        hasNewContent = dictionaryRepresentation["hasNewContent"] as! Bool
//        newMediaIndex = dictionaryRepresentation["newMediaIndex"] as? Int
    }
    
    

    func uploadAlbum(onCompletion closure: (successful :Bool) ->() ){
        
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
                        let albumId = objectAsDictionary[kAlbumId] as? Int
                        
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
    
    
    func updateACL(acl: [String], onCompletion closure: (successful :Bool) ->() ){
    
        isUploading = true
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]    = Me.guid()
        jsonObj["friends"] = acl
        jsonObj[ "id"]    = id
        
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaUpdateAlbum,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            self.isUploading = false
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    print("CloudLogicViewController: Result: \(result)")
                    
                    if let objectAsDictionary = result as? [String: AnyObject] {
                        
                        let success = objectAsDictionary["Success"] as! Bool
                        let albumId = objectAsDictionary["AlbumId"] as? Int
                        
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

        jsonObj[kGuid]     = Me.guid()
        jsonObj["action"] = "Title"
        jsonObj["albumId"] = id
        jsonObj["title"] = title
        
        
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
    
    
    
    
    
    func insertPhotoImage(photo: UIImage) {
     
        coverPhotoImage = photo
        let newMedia = MediaModel(withPhoto: photo)
        mediaContent.append(newMedia)
        
        if var count = mediaCount {
            count += 1
            mediaCount = count
        }
    }
    
    
    func insertRepresentationString(title: String, forObject:AnyObject){
        
    }
    
    
    func firstNewItem() -> MediaModel? {
        
        print("firstNewItem currentItemIndex: \(currentItemIndex)")

        if let index = newMediaIndex {
            currentItemIndex = index
            print("firstNewItem currentItemIndex: \(currentItemIndex), newMediaIndex = \(newMediaIndex!)")

            mediaContent[currentItemIndex].isNew = false
            return mediaContent[currentItemIndex]
        }
        return nil
    }
    
    func firstItem() -> MediaModel? {
        
        if !mediaContent.isEmpty {
            currentItemIndex = 0
            return mediaContent[currentItemIndex]
            
        }
        return nil
    }
    
    func anymoreNewItems() -> Bool {
        
        for index in 0..<mediaContent.count {
            if mediaContent[index].isNew {
                print("Content at index:\(index) is still new")
                return true
            }
        }
        return false
    }
    
    func nextItem() -> MediaModel? {
        
        currentItemIndex += 1
        
        
        print("mediaContent.count: \(mediaContent.count)")
        print("mediaCount: \(mediaCount!)")
        print("currentItemIndex:\(currentItemIndex) < mediaContent.count:\(mediaContent.count)")
        
        if currentItemIndex < mediaContent.count {
            mediaContent[currentItemIndex].isNew = false
            return mediaContent[currentItemIndex]
        }

        hasNewContent = false
        print("Assume: no more images")
        
        if currentItemIndex == mediaContent.count {
            print("Assuming: no more images")
        }
        
        if !anymoreNewItems() {
            print("Confirmed: no more images")
        }

        return nil

    }
    
    
    func previousItem() -> MediaModel? {
        
        if currentItemIndex > 0 {
            currentItemIndex -= 1
            return mediaContent[currentItemIndex]
        }
        return nil
    }
    
    
    
    func titleAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: title, fontSize: size, color: UIColor.blackColor(), firstWordColor: nil)
    }
    
    func uploadDateAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: uploadDateString, fontSize: size, color: UIColor.blackColor(), firstWordColor: nil)
    }
    
    
    func timeAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: time, fontSize: size, color: UIColor.lightGrayColor(), firstWordColor: nil)
    }
}