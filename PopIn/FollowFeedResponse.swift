//
//  FollowFeedResponse.swift
//  PopIn
//
//  Created by Hanny Aly on 8/31/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation






class FollowFeedResponse {
    
    struct Album {
        var albumId    :String
        var title      :String
        var date       :String
        var newestTime :String?
        var newestUrl  :String?
        var mediaCount :Int
    }
    
    var albums: [FriendAlbumModel]
    
    var hasNewContent = false
    
    init?(response result: AnyObject?) {
        
        if let response = result as? [String: AnyObject]  {
                        
            albums = [FriendAlbumModel]()
            
            if response[kSuccess] as? Bool == nil {
               return nil
            }
            
            if let albums = response[kAlbums] as? [ AnyObject ] {
                
                for album in albums {
                    
                    let fguid      = album[kGuid] as! String
                    let username   = album[kUserName] as! String
                    let fullname   = album[kFullName] as! String
                    let verified   = album[kVerified] as! Bool
                    
                    let albumId    = album[kAlbumId] as! String
                    let title      = album[kTitle]   as! String
                    let mediacount = album[kCount]   as! Int

                    
                    
                    let lastViewedMediaUrl       = album[kLastViewedMediaUrl]       as? String
                    let lastViewedMediaTimestamp = album[kLastViewedMediaTimestamp] as? String
                   
                    
                    
                    let lastViewedMediaDate: NSDate? = lastViewedMediaTimestamp != nil ? NSDate(fromString: lastViewedMediaTimestamp!, format: .ISO8601(nil)) : nil

                    
                    let newestMediaUrl           = album[kNewestMediaUrl]       as! String
                    let newestMediaTimestamp     = album[kNewestMediaTimestamp] as! String
                    
                    let newestMediaDate  = NSDate(fromString:  newestMediaTimestamp, format: .ISO8601(nil))
                    
                                        
                    let friendAlbum = FriendAlbum(guid: fguid,
                                                  username: username,
                                                  fullname: fullname,
                                                  verified: verified,
                                                  albumId: albumId,
                                                  title: title,
                                                  mediaCount: mediacount,
                                                  newestTimestamp: newestMediaDate,
                                                  newestUrl: newestMediaUrl,
                                                  lastViewedTimestamp: lastViewedMediaDate,
                                                  lastViewedUrl: lastViewedMediaUrl)
                                                  
                    
                    let friendAlbumModel = FriendAlbumModel(withAlbum: friendAlbum)
                    
                    if friendAlbumModel.hasNewContent() {
                        hasNewContent = true
                    }
                    
                    self.albums.append(friendAlbumModel)
                }
            }
        } else {
            return nil
        }
    }
}