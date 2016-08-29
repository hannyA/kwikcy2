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
    
    struct Album {
        var albumId    :String
        var title      :String
        var date       :String
        var newestTime :String?
        var newestUrl  :String?
        var mediaCount  :Int?
    }
    
    
    var albums: [Album]
    
    init?(response result: AnyObject?) {
        
        if let response = result as? [String: AnyObject]  {
            
            if (response[kErrorMessage] as? String) != nil {
                return nil
            }
            
            albums = [Album]()
            
            
            if let albums = response[kAlbums] as? [ AnyObject ] {
                
                for album in albums {
                    
                    let albumId    = album[kAlbumId] as! String
                    let title      = album[kTitle] as! String
                    let date       = album[kCreateDate] as! String
                    let newestTime = album[kNewestMediaTime] as? String
                    let newestUrl  = album[kNewestMediaUrl] as? String
                    let mediaCount  = album[kCount] as? Int

                    
                    let album = Album(albumId: albumId,
                                       title: title,
                                       date: date,
                                       newestTime: newestTime,
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