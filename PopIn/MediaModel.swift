//
//  MediaModel.swift
//  PopIn
//
//  Created by Hanny Aly on 6/6/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


protocol MediaModelDelegate {
    func updateVCForTimeLeft(time: Int)
}

class MediaModel {
    
    enum MediaType: String {
        case Photo = "photo"
        case Video = "video"
        case Gif   = "gif"
       
    }
    
    var delegate:MediaModelDelegate?
    
    var type: MediaType
    
//    var photo: UIImage?
//    var photoData: NSData?
    
//    var mediaURL: NSURL?
    
    var mediaData    : NSData
    var mediaKey     : String
    
    
    var timeLimit: Int?
    var timeLeft: Int?
    
    var date: String?
    var isNew: Bool

    
    var timer: NSTimer?

    // If video, no time limit
//    init(mediaType:MediaType, mediaURL url: String, timeLimit time: Int?, isNew new: Bool ) {
//        
//        type = mediaType
//        if type == .Photo {
//            mediaURL = NSURL(string: url)
////            let image = UIImage(data: <#T##NSData#>)
//            timeLimit = time
//        } else {
//            
//        }
//
//        media = image
//        viewTime = time
//        isNew = new
//        // date = "some Date"
//        
//    }
    
//    object[kAlbumId]   = albumId
//    object[kType]      = result.type // video, gif, photo
//    object[kMediaURL]  = result.media_url
//    object[kTimestamp] = result.timestamp;
//    object[kTimelimit] = result.timelimit
    
    
    class func mediaType(type: String) -> MediaType {
        
        switch type {
        case "photo":
            return .Photo
        case "video":
            return .Video
        case "gif":
            return .Gif
        default:
            return .Photo
        }
    }
    
    
    //Folder is actually a guid
    
    init(mediaData base64Data: String, type _type: String, mediaUrl: String, timeLimit timelimit: Int?, timestamp: String, isNew new: Bool) {
        
        type = MediaModel.mediaType(_type)
        
        let decodedData = NSData(base64EncodedString: base64Data,
                                 options: .IgnoreUnknownCharacters)!
        
        
        
//        let dataDecoded:NSData = NSData(base64EncodedString: base64Data,
//                                        options: NSDataBase64DecodingOptions(rawValue: 0))!
//        let decodedimage:UIImage = UIImage(data: dataDecoded)!

        mediaKey = mediaUrl
        
        mediaData   = decodedData
        timeLimit   = timelimit
        isNew       = new
        date        = timestamp
    }
    
//    init(withImage image: String, andTimeLimit time: Int, isNew new: Bool ) {
//        
//        type = .Photo
//        media = image
//        timeLimit = time
//        isNew = new
//        //        date = "some Date"
//        
//    }
//    
//    init(withPhoto photo: UIImage ) {
//    
//        type = .Photo
//        self.photo = photo
//        isNew = true
//    }
    
    @objc func updateVC() {
        timeLeft = timeLeft! - 1
        delegate?.updateVCForTimeLeft(timeLeft!)
    }
    

    
    func startTimer() {
        print("Timerlimit: \(timeLimit!)")
        timeLeft = timeLimit
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
                                                       target: self,
                                                       selector: #selector(updateVC),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    func continueTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
                                                       target: self,
                                                       selector: #selector(updateVC),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    func timerIsRunning() -> Bool {
     
        if let timer = timer {
            if timer.valid {
                return true
            }
        }
        return false
    }
        
    
    func stopTimer() {
        print("Stoping timer")
        if let timer = timer {
            if timer.valid {
                print("Timer invalidate")

                timer.invalidate()
            }
        }
    }
    
    
}


