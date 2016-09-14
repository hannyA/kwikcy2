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
//import RealmSwift


class AlbumModel {
    
    var id: String?
    var title: String?
    
    var coverPhoto: String?
    var coverPhotoURL: NSURL?
    var coverPhotoImage: UIImage?
    var coverPhotoData: NSData?
    
    var createDate: NSDate?
    
    var uploadDateRaw: String?
//    var uploadDateString: String?
//    var time: String?  // last photo update time
   
    
    var urlString: String?
    var URL: NSURL? // urlString ? [NSURL URLWithString:urlString] : nil;
    
    var totalMediaCount: Int = 0   // Total number in album
    
    var mediaContent = [MediaModel]()  //later urls? or NSData
    
        
    var currentItemIndex = 0
    var newMediaIndex   : Int?
    
    // var isBeingCreated = false

    var isUploading   = false
    var isDownloading = false
    
    
    
    
    
    
    // Getting a list of albums, either ours or friends
    init(id: String, title:String, date: NSDate, count: Int)  {
        
        self.id         = id
        self.title      = title
        self.createDate = date
        totalMediaCount = count
    }
    
    
    // Getting a list of albums, either ours or friends
    init(withAlbum album: UserAlbum) {
        
        
        title           = album.title
        id              = album.albumId
        createDate      = album.date
        totalMediaCount = album.mediaCount
        
//        mediaContent = dictionaryRepresentation["mediaContent"] as? [MediaModel]
//        hasNewContent = dictionaryRepresentation["hasNewContent"] as! Bool
//        newMediaIndex = dictionaryRepresentation["newMediaIndex"] as? Int
    }
    
    
    func hasContent() -> Bool {
        
        if mediaContent.count > 0 {
            return true
        }
        return false
    }
    
    
    func hasEnoughContentToPresent() -> Bool {
        
        print("mediaContent.count: \(mediaContent.count), totalMediaCount: \(totalMediaCount)")
        
        if ( mediaContent.count > 0 && mediaContent.count == totalMediaCount ) || mediaContent.count  > 5  {
            return true
        }
        return false
    }
    
    
    func mediaCount() -> Int {
        return mediaContent.count
    }

    
 
    
//    // TODO: Validate mediaUrl and timestamp
//    

    
    
    
    
    func downloadMediaContent(onCompletion closure: (didGetNewContent :Bool, errorMessage: String?) ->() ){
        
        print("downloadMediaContent")
        //        AWSLambdaOpenAlbum
        
        if isDownloading {
            return
        }
        
        isDownloading = true
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]      = Me.sharedInstance.guid()
        jsonObj[kAcctId]    = Me.sharedInstance.acctId()
        jsonObj[kAlbumId]  = id
        jsonObj[kMediaURL]  = mediaContent.last?.mediaKey
        jsonObj[kTimestamp] = mediaContent.last?.date
        
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaOpenAlbum,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            self.isDownloading = false
            
            print("result: \(result)")

            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    var didGetNewContent = false
                    if let objectAsDictionary = result as? [String: AnyObject] {
                        
                        
                        let albumStillExists = objectAsDictionary["AlbumExists"] as! Bool
                        let errorMessage = objectAsDictionary[kErrorMessage] as? String
                        
                        if albumStillExists {
                            print("albumStillExists")

                            
                            if let album = objectAsDictionary["Album"] as? [[String: AnyObject]] {
                                
                                print("mediaModel == nil")

                                for media in album {
                                    
                                    let newMediaContent = MediaModel(mediaData: media[kMedia] as! String,
                                                                     type     : media[kType] as! String,
                                                                     mediaUrl : media[kMediaURL] as! String,
                                                                     timeLimit: media[kTimelimit] as? Int,
                                                                     timestamp: media[kTimestamp] as! String,
                                                                     isNew    : false)
                                    
                                    
                                    // We shouldn't really have to do this, but to be safe?
                                    if self.mediaContent.indexOf({ (mediaModel) -> Bool in
                                        
                                        if mediaModel.mediaKey == newMediaContent.mediaKey {
                                            return true
                                        }
                                        return false
                                    }) == nil {
                                        
                                        print("mediaModel == nil")

                                        didGetNewContent = true
                                        self.mediaContent.append(newMediaContent)
                                    }
                                }
                            }
                            closure(didGetNewContent: didGetNewContent, errorMessage: nil)

                            
                        } else {
                            closure(didGetNewContent: didGetNewContent, errorMessage: errorMessage)
                        }
                    } else {
                        closure(didGetNewContent: didGetNewContent, errorMessage: nil)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                dispatch_async(dispatch_get_main_queue(), {
                    closure(didGetNewContent: false, errorMessage: AWSErrorBackend)
                })
            }
        }
    }
    
    
    
    
    
    
    
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
    
//    func uploadDateAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
//        return NSAttributedString(string: uploadDateString, fontSize: size, color: UIColor.blackColor(), firstWordColor: nil)
//    }
//    
//    
//    func timeAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
//        return NSAttributedString(string: time, fontSize: size, color: UIColor.lightGrayColor(), firstWordColor: nil)
//    }
}