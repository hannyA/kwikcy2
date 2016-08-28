//
//  MyAlbums.swift
//  PopIn
//
//  Created by Hanny Aly on 8/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AWSMobileHubHelper

class MyAlbums {
    
    private var albums: [AlbumModel]
    private var newAlbums: [AlbumModel]
    //    var publicAlbums: [AlbumModel]
    
    
    init() {
        albums    = [AlbumModel]()
        newAlbums = [AlbumModel]()
    }
    
    
    func oldCount() -> Int {
        return albums.count
    }
    func newCount() -> Int {
        return newAlbums.count
    }
    func totalCount() -> Int {
        return oldCount() + newCount()
    }
    
    
    func insertNewAlbum(album: AlbumModel) {
        newAlbums.insert(album, atIndex: 0)
    }
    
    
    func oldAlbumAtIndex(index: Int) -> AlbumModel {
        return albums[index]
    }
    func newAlbumAtIndex(index: Int) -> AlbumModel {
        return newAlbums[index]
    }

//    func albumsEmpty() -> Bool {
//        return albums.isEmpty
//    }
    
    func newEmpty() -> Bool {
        return newAlbums.isEmpty
    }
    
    func oldEmpty() -> Bool {
        return albums.isEmpty
    }
    
    
    func bothFilled() -> Bool {
        return !oldEmpty() && !newEmpty()
    }
    
    func bothEmpty() -> Bool {
        return oldEmpty() && newEmpty()
    }
    
    func onlyOneFilled() -> Bool {
        return !bothFilled() && !bothEmpty()
    }
    
    
    func indexOfAlbum(album:AlbumModel, inList list: [AlbumModel]) -> Int? {
        
        let index = list.indexOf { (albumModel) -> Bool in
            if album === albumModel {
                return true
            }
            return false
        }
        return index
    }
    
    
    func findAlbum(album: AlbumModel) -> (section: Int, row: Int)? {
        
        if let index = indexOfAlbum(album, inList: newAlbums) {
            return (0, index)
        } else if let index = indexOfAlbum(album, inList: albums) {
            if newEmpty() {
                return (0, index)
            } else {
                return (1, index)
            }
        }
        return nil
    }
    
    
    func load(completionClosure: (success: Bool) ->()) {
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaMyAlbums,
         withParameters: nil) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("profileModel: CloudLogicViewController: Result: \(result)")
                    
                    if let myAlbumsList = AlbumResponse(response: result) {
                        
                        for albumItem in myAlbumsList.albums {
                            
                            let album = AlbumModel(withAlbum: albumItem)
                            self.albums.append(album)
                        }
                        completionClosure(success: true)
                        
                    } else {
                        completionClosure(success: false)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(success: false)
                })
            }
        }
    }
    
    func albumsIds(albums:[AlbumModel]) -> [String] {
        
        var uploadAlbums = [String]()
        
        for album in albums {
            if let id = album.id {
                uploadAlbums.append(String(id))
            }
        }
        return uploadAlbums
    }
    
    
    func uploadMedia(media: UIImage, to albums: [AlbumModel], completionClosure: (success: Bool) ->()) {
        
        print("uploadMedia")
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaUploadMedia,
         withParameters: nil) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("profileModel: CloudLogicViewController: Result: \(result)")
                    
                    if let myAlbumsList = AlbumResponse(response: result) {
                        
                        for albumItem in myAlbumsList.albums {
                            
                            let album = AlbumModel(withAlbum: albumItem)
                            self.albums.append(album)
                        }
                        completionClosure(success: true)
                        
                    } else {
                        completionClosure(success: false)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                print("profileModel: CloudLogicViewController: Result: \(result)")

                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(success: false)
                })
            }
        }

    }
    
    
    
    func uploadMedia(base64Encoded: String, type: String, timelimit: Int, to albums: [AlbumModel], completionClosure: (success: Bool, errorMessage: String?) ->()) {
        
        print("uploadMedia")

        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]      = Me.guid()
        jsonObj[kAcctId]    = Me.acctId()

        jsonObj[kMedia]     = base64Encoded
        jsonObj[kType]      = type
        jsonObj[kTimelimit] = timelimit
        jsonObj[kAlbumIds] = albumsIds(albums)
        
        
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaUploadMedia,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("uploadMedia: CloudLogicViewController: Result: \(result)")
                    
                    if let response = result as? [String: AnyObject]  {
                        
                        let successful   = response[kSuccess] as! Bool
                        let errorMessage = response[kErrorMessage] as? String
                        
                        completionClosure(success: successful, errorMessage: errorMessage)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                print("uploadMedia: failed")

                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(success: false, errorMessage: AWSErrorBackend)
                })
            }
        }
    }
}



