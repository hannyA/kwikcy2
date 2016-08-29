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
import RealmSwift

class AlbumModel {
    
    var dictionaryRepresentation: [String: AnyObject]

    var id: String?
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
    
//    var mediaCount: Int = 0   // Number we have in memory
    var totalMediaCount: Int? = 0   // Total number in album
    
    var mediaContent = [MediaModel]()  //later urls? or NSData
    
    
    var hasNewContent: Bool
    
    var currentItemIndex = 0
    var newMediaIndex: Int?
    
//    var isBeingCreated = false

    var isUploading = false
    var lastUploadSuccessful = true

    
    var lastMediaObject: String? // Maybe this should be a local URL
    var lastType: String?
    var lastTimelimit: Int?
    
    
    typealias Guid = String
    var acl: [Guid]?
    
    
    func hasContent() -> Bool {
        
        if mediaContent.count > 0 {
            return true
        }
        return false
    }
    
    
    func hasEnoughContentToPresent() -> Bool {
        
        if mediaContent.count == totalMediaCount || mediaContent.count  > 5  {
            return true
        }
        return false
    }
    
    
    func mediaCount() -> Int {
        return mediaContent.count
    }
    
    
//    var onUsernamesChanged: ([String]->())?
//
//    var loadedUsernames = [String]() {
//        didSet {
//            onUsernamesChanged?(loadedUsernames)
//        }
//    }
//    
//    var finishedUploading: ((Bool)->())?
    
//    typealias completion = (result: String)->()
//    
//    var onComplete: (completion)? //an optional function

    
//    func finishedUploadingwith(success: Bool) {
//        isUploading = false
//        finishedUploading?(success)
//        
//    }
    
    
    // For creating new albums
    init(withTitle title: String, usersAccessControlList usersGuids: [String]) {
        
        self.title = title
        self.acl = usersGuids
        
//        
//        let realmAlbum = Album()
//        realmAlbum.title = title
//        realmAlbum.acl.appendContentsOf(userList(acl!))
//        
//        
//        let realm = try! Realm()
//        try! realm.write() {
//            
//            realm.create(Album.self, value: realmAlbum, update: false)
//            
//            //            (Album.self, value: ["Jane", 27])
//            //            // Reading from or modifying a `RealmOptional` is done via the `value` property
//            //            person.age.value = 28
//        }

        
        
        dictionaryRepresentation = [String: AnyObject]()
        dictionaryRepresentation["title"] = self.title
        hasNewContent = false
    }
    
    
    
    // Getting a list of albums, either ours or friends
    init(withAlbum album: AlbumResponse.Album) {
        
        
        title           = album.title
        id              = album.albumId
        createDate      = album.date
        newestMediaUrl  = album.newestUrl
        newMediaTime    = album.newestTime
        totalMediaCount = album.mediaCount
        
        
        dictionaryRepresentation = [String: AnyObject]()
        dictionaryRepresentation[kTitle]          = album.title
        dictionaryRepresentation[kAlbumId]        = album.albumId
        dictionaryRepresentation[kDate]           = album.date
        dictionaryRepresentation[kTimestamp]      = album.newestTime
        dictionaryRepresentation[kNewestMediaUrl] = album.newestUrl

        hasNewContent = false
        
//        mediaContent = dictionaryRepresentation["mediaContent"] as? [MediaModel]
//        hasNewContent = dictionaryRepresentation["hasNewContent"] as! Bool
//        newMediaIndex = dictionaryRepresentation["newMediaIndex"] as? Int
    }

//    init(withAlbumInfo info: [String: AnyObject]) {
//       
//        dictionaryRepresentation = info
//        hasNewContent = false
////        mediaContent = dictionaryRepresentation["mediaContent"] as! [MediaModel]
////        hasNewContent = dictionaryRepresentation["hasNewContent"] as! Bool
////        newMediaIndex = dictionaryRepresentation["newMediaIndex"] as? Int
//    }
    
    func retryUploadingLastMedia(onCompletion closure: (successful :Bool, errorMessage: String?) ->() ){
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]      = Me.guid()
        jsonObj[kAcctId]    = Me.acctId()
        
        jsonObj[kMedia]     = lastMediaObject
        jsonObj[kType]      = lastType
        jsonObj[kTimelimit] = lastTimelimit
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

        jsonObj[kGuid]     = Me.guid()
        jsonObj["action"] = "Title"
        jsonObj[kAlbumId] = id
        jsonObj[kTitle] = title
        
        
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
    
    
    
//    var fguid       = event[kFGuid];
//    
//    // TODO: Validate mediaUrl and timestamp
//    
//    var lastMediaUrl  = event[kMediaURL];
//    var lastTimestamp = event[kTimestamp]

    
    
    func downloadMediaContent(onCompletion closure: (successful :Bool, errorMessage: String?) ->() ){
        
//        AWSLambdaOpenAlbum
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]    = Me.guid()
        jsonObj[kAcctId]  = Me.acctId()
        jsonObj[kAlbumId] = id
        
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaOpenAlbum,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            self.isUploading = false
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if let objectAsDictionary = result as? [String: AnyObject] {
                        

                        let albumExists = objectAsDictionary["AlbumExists"] as! Bool
                        let album = objectAsDictionary["Album"] as? [[String: AnyObject]]
                        let errorMessage = objectAsDictionary[kErrorMessage] as? String

                        if albumExists {
                            
                            for media in album! {
                               
                                let newMediaContent = MediaModel(newMedia: media[kMedia] as! String,
                                    type: media[kType] as! String,
                                    timeLimit: media[kTimelimit] as? Int,
                                    timestamp: media[kTimestamp] as! String,
                                    isNew: false)
                            
                                self.mediaContent.append(newMediaContent)
                            
                            }
                            closure(successful: true, errorMessage: nil)
                        } else {
                            closure(successful: false, errorMessage: errorMessage)
                        }
                    } else {
                        closure(successful: false, errorMessage: nil)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                dispatch_async(dispatch_get_main_queue(), {
                    closure(successful: false, errorMessage: AWSErrorBackend)
                })
            }
        }
    }
    
    //            closure(successful: true)

    
    

    //    private func randomMediaContent() -> ( [MediaModel], Bool, Int) {
    //
    //        var newMediaExists = isNewMedia()
    //        var returnValueMediaExists = false
    //
    //        var newMediaExistsAtIndex = 0
    //        let numberOfContent = Int(arc4random_uniform(UInt32(10)))
    //
    //        var contentList = [MediaModel]()
    //
    //
    //        for _ in 0...numberOfContent {
    //
    //            if newMediaExists {
    //
    //                contentList.append(MediaModel(withImage: randomMediaContentStrings(),
    //                                              andTimeLimit: randomTimerLimit(),
    //                                              isNew: newMediaExists))
    //                returnValueMediaExists = true
    //
    //            } else {
    //                contentList.append(MediaModel(withImage: randomMediaContentStrings(),
    //                                              andTimeLimit: randomTimerLimit(),
    //                                              isNew: newMediaExists))
    //
    //                newMediaExists = isNewMedia()
    //                newMediaExistsAtIndex += 1
    //            }
    //        }
    //        
    //        return (contentList, returnValueMediaExists, newMediaExistsAtIndex)
    //    }

    
    
    
    
    
    
//    func insertPhotoImage(photo: UIImage) {
//     
//        coverPhotoImage = photo
//        let newMedia = MediaModel(withPhoto: photo)
//        mediaContent.append(newMedia)
//        
////        if var count = mediaCount {
////            count += 1
////            mediaCount = count
////        }
//    }
    
    
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