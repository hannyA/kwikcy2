//
//  Album.swift
//  PopIn
//
//  Created by Hanny Aly on 5/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation


import AFDateHelper



struct FriendAlbum {
    var guid       :String
    var username   :String
    var fullname   :String
    var verified   :Bool
    
    var albumId    :String
    var title      :String
    var mediaCount :Int
    
    var newestTimestamp     :NSDate
    var newestUrl           :String
    var lastViewedTimestamp :NSDate?
    var lastViewedUrl       :String?
}



class FriendAlbumModel: AlbumModel {

    var lastViewedUrl       :String?
    var lastViewedTimestamp :NSDate?

    
    var newestMediaUrl: String
    var newestMediaTime: NSDate
    

    var ownerProfile: UserModel

    
    
    

    // Getting a list of albums, either ours or friends
    init(withAlbum album: FriendAlbum) {
        
        lastViewedTimestamp = album.lastViewedTimestamp
        lastViewedUrl       = album.lastViewedUrl
        
        
        
        newestMediaTime     = album.newestTimestamp
        newestMediaUrl      = album.newestUrl
        
        
        let userModel = UserModel.BasicInfo(guid: album.guid,
                                            username: album.username,
                                            fullname: album.fullname,
                                            verified: nil,
                                            blocked : nil)
        
        ownerProfile = UserModel(withBasic: userModel, imageType: .Crop)

        super.init(id: album.albumId, title: album.title, date: NSDate(), count: album.mediaCount)

//        
//        print("lastViewedTimestamp:\(lastViewedTimestamp)")
//        print("lastViewedTimestamp:\(newestMediaTime)")
//        
//        
//        let date  = NSDate(fromString:  "2009-08-11T06:00:00-07:00", format: .ISO8601(nil))
//        let date2 = NSDate(fromString:  "2016-08-31T01:44:44.000Z",  format: .ISO8601(nil))
//        
//        print("date  \(date)")
//        print("date2 \(date2)")
//    
//    
//        
//        let now = NSDate().timeIntervalSince1970
//        print("now \(now)")
//
//        let todaysDate = NSDate(timeIntervalSince1970: now)
//        print("todaysDate \(todaysDate)")
//
//        let seconds = date2.secondsBeforeDate(todaysDate)
//        let hours = date2.hoursBeforeDate(todaysDate)
//        let days = date2.daysBeforeDate(todaysDate)
//        
//        print("This occered: \(seconds) seconds ago")
//        print("This occered: \(hours) hours ago")
//        print("This occered: \(days) days ago")

    }
    
    func hasBeenViewed() -> Bool {
        return lastViewedTimestamp != nil
    }
    
    //lastViewedTimestamp < newestMediaTime
    
    func hasNewContent() -> Bool {
        
        return lastViewedTimestamp?.compare(newestMediaTime) == .OrderedAscending
    }
    
    
    func equalTo(album: FriendAlbumModel) -> Bool {
       
        print("id: \(id!),  album.id: \(album.id!)")
        print("ownerProfile.guid:\(ownerProfile.guid), album.ownerProfile.guid\(album.ownerProfile.guid)")
        
        return (id! == album.id! && ownerProfile.guid == album.ownerProfile.guid)
    }
    
    func shouldBeDeleted() -> Bool {
        
        return !NSDate.stillLegal(newestMediaTime)
        
        
    }
    
    func shouldBeUpdated(serverAlbum: FriendAlbumModel) -> Bool {
        
        //if album.newestMediaTime > newestMediaTime

        if serverAlbum.newestMediaTime.compare(newestMediaTime) == .OrderedDescending {
            
            newestMediaTime     = serverAlbum.newestMediaTime
            newestMediaUrl      = serverAlbum.newestMediaUrl
            
            return true

        }
        
        return false
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
    
    
    override func nextItem() -> MediaModel? {
        
        if let mediaModel = super.nextItem() {
            return mediaModel
        }
       
//        hasNewContent = false

        return nil
    }
    

    
    
    override func titleAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: title, fontSize: size, color: UIColor.blackColor(), firstWordColor: nil)
    }
    
    
//    func uploadDateAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
//        return NSAttributedString(string: uploadDateString, fontSize: size, color: UIColor.blackColor(), firstWordColor: nil)
//    }
    
    
    func timeAttributedStringWithFontSize(size: CGFloat) -> NSAttributedString {
        
        
        let timeago = NSDate().timeAgoFromDate(newestMediaTime)
        
        return NSAttributedString(string: timeago,
                                  fontSize: size,
                                  color: UIColor.lightGrayColor(),
                                  firstWordColor: nil)
    }
    
    

    
}