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
    
    // Shared instance of this class
    static let sharedInstance = MyAlbums()
    var isInitialized: Bool
    
    
    private var albums: [AlbumModel]
    private var newAlbums: [AlbumModel]
    //    var publicAlbums: [AlbumModel]
    
    
    // Changed when we create a new Album and
    var shouldUpdateTable = false
    
    // Sort by title, last input date
    
    init() {
        albums    = [AlbumModel]()
        newAlbums = [AlbumModel]()
        isInitialized = false
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
    
    func clearNewAlbums() {
        newAlbums.removeAll()
    }
    
    
//    func moveNewSelectedAlbumsToOld() {
//        
//        albums.appendContentsOf(newAlbums)
//        newAlbums.removeAll()
//    }
    
    
    func indexOfAlbum(album:AlbumModel, inList list: [AlbumModel]) -> Int? {
        
        return list.indexOf { (albumModel) -> Bool in
            if album === albumModel {
                return true
            }
            return false
        }
    }
    
    
    func albumsIds(albums:[AlbumModel]) -> [String] {
        
        var uploadAlbums = [String]()
        
        for album in albums {
            if let id = album.id {
                uploadAlbums.append(id)
            }
        }
        return uploadAlbums
    }
    
    
    func findAlbum(album: AlbumModel) -> NSIndexPath? {
        
        if let index = indexOfAlbum(album, inList: newAlbums) {
            return NSIndexPath(forRow: 0, inSection: index)
        } else if let index = indexOfAlbum(album, inList: albums) {
            if newEmpty() {
                return NSIndexPath(forRow: 0, inSection: index)
            } else {
                return NSIndexPath(forRow: 1, inSection: index)
            }
        }
        return nil
    }
    
    
    
    func load(completionClosure: (success: Bool) ->()) {
        
        print("AWSLambdaMyAlbums being called")
        if isInitialized {
            completionClosure(success: true)
            return
        }
        
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

                        self.isInitialized = true

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
    
    
    
    func uploadMedia(base64Encoded: String, type: String, timelimit: Int, to selectedAlbums: [AlbumModel], completionClosure: (success: Bool, errorMessage: String?) ->()) {
        
        print("uploadMedia to \(selectedAlbums.count) albums")
       
        for selectedAlbum in selectedAlbums {
            
            if let _ = indexOfAlbum(selectedAlbum, inList: newAlbums) {
                
                shouldUpdateTable = true
                albums.append(selectedAlbum)
            }
        }
        
        newAlbums.removeAll()
        
        
        albums.sortInPlace { (album1, album2) -> Bool in
            return album1.title < album2.title
        }
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]      = Me.guid()
        jsonObj[kAcctId]    = Me.acctId()

        jsonObj[kMedia]     = base64Encoded
        jsonObj[kType]      = type
        jsonObj[kTimelimit] = timelimit
        jsonObj[kAlbumIds]  = albumsIds(albums)
        
        for album in selectedAlbums {
            album.isUploading = true
            
            album.lastUploadedMediaObject = base64Encoded
            album.lastUploadedType        = type
            album.lastUploadedTimelimit   = timelimit
        }
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaUploadMedia,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            
            for album in selectedAlbums {
                album.isUploading = false
            }
            

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



