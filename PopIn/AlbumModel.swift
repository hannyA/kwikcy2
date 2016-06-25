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


class AlbumModel {
    
//    var delegate: AlbumModelDelegate?

    var dictionaryRepresentation: [String: AnyObject]

    var id: String?
    var title: String?
    var ownerProfile: UserModel?
    
    var coverPhoto: String?
    var coverPhotoURL: NSURL?
    var coverPhotoImage: UIImage?
    var coverPhotoData: NSData?
    
    
    var coverPhotoThumbnail: String?
    var coverPhotoThumbnailURL: NSURL?
    var coverPhotoThumbnailImage: UIImage?
    var coverPhotoThumbnailData: NSData?
    
    
    
    var uploadDateRaw: String?
    var uploadDateString: String?
    var time: String? // last photo update time
   
    var urlString: String?
    var URL: NSURL? // urlString ? [NSURL URLWithString:urlString] : nil;
    
    var mediaCount: Int?
    
    var mediaContent: [MediaModel] //later urls? or NSData
    
    var hasNewContent: Bool
    
    var currentItemIndex = 0
    var newMediaIndex: Int?
    
    var isUploading = false
    
    init(withTitle title: String) {
        
        self.title = title
        mediaCount = 0
        
        dictionaryRepresentation = [String: AnyObject]()
        dictionaryRepresentation["title"] = self.title
        mediaContent = [MediaModel]()
        hasNewContent = false
    }
    
    init(withAlbumInfo info: [String: AnyObject]) {
       
        dictionaryRepresentation = info
        
        mediaContent = dictionaryRepresentation["mediaContent"] as! [MediaModel]
        hasNewContent = dictionaryRepresentation["hasNewContent"] as! Bool
        newMediaIndex = dictionaryRepresentation["newMediaIndex"] as? Int
    }
    
    
//    
//    func createNewAlbumWithCompletionBlock(completionClosure: (albumResults :[AlbumModel]) ->(), newAlbum: AlbumModel, usersAccessControlList: [UserModel] ) {
    

    func uploadAlbum(newAlbum: AlbumModel) {
        
        isUploading = true
        // start spinning
        
        
        // Server call simulation
        print("Simulating server call")

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(kWebResponseDelay * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            
            self.isUploading = false
            NSNotificationCenter.defaultCenter().postNotificationName("kAlbumUploadNotification", object: self, userInfo: ["success": true])

//            NSNotificationCenter.defaultCenter().postNotificationName("kAlbumUploadNotification", object: nil)

//            self.delegate?.uploadAlbum(newAlbum, completeWithSuccess: true)
        }
    }
    
    
//    func uploadComplete(completed: Bool, completionBlock completionClosure: (albumResults :[AlbumModel]) ->()){
//       
//        // Server call Imitation
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(kWebResponseDelay * NSEC_PER_SEC)), dispatch_get_main_queue()) {
//            
//            
//            print("done here")
//            
//            
//        }
    
//        
//    }
    
    
    
    func insertPhotoImage(photo: UIImage) {
     
        coverPhotoImage = photo
        let newMedia = MediaModel(withPhoto: photo)
        mediaContent.append(newMedia)
        
        if var count = mediaCount{
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
        return NSAttributedString(string: title, fontSize: size, color: UIColor.lightGrayColor(), firstWordColor: nil)
    }
    
    func uploadDateAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: uploadDateString, fontSize: size, color: UIColor.lightGrayColor(), firstWordColor: nil)
    }
    
    
    func timeAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: time, fontSize: size, color: UIColor.lightGrayColor(), firstWordColor: nil)
    }
}