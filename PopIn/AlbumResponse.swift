//
//  AlbumResponse.swift
//  PopIn
//
//  Created by Hanny Aly on 8/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation


let kAlbums = "Albums"




class AlbumResponse {
    
    var albums: [UserAlbum]
    
    init?(response result: AnyObject?) {
        
        if let response = result as? [String: AnyObject]  {
            
            if (response[kErrorMessage] as? String) != nil {
                return nil
            }
            
            albums = [UserAlbum]()
            
            
            if let albums = response[kAlbums] as? [ AnyObject ] {
                
                for album in albums {
                    
                    let albumId    = album[kAlbumId] as! String
                    let title      = album[kTitle] as! String
                    
                    let createTimestamp  = album[kCreateDate] as! String
                    let createDate  = NSDate().fromTimestamp(createTimestamp)

                    let newestTimestamp = album[kNewestMediaTimestamp] as! String
                    let newestDate  = NSDate().fromTimestamp(newestTimestamp)

                    
                    let newestUrl  = album[kNewestMediaUrl] as! String
                    let mediaCount = album[kCount] as! Int

                    print("this count: mediaCount: \(mediaCount),  album[kCount]: \( album[kCount])")
                    
                    let album = UserAlbum(albumId: albumId,
                                           title: title,
                                           date: createDate,
                                           newestTime: newestDate,
                                           newestUrl: newestUrl,
                                           mediaCount: mediaCount)
                    
                    self.albums.append(album)
                }
            }
        } else {
            return nil
        }
    }
}