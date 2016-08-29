////
////  ProfileModel.swift
////  PopIn
////
////  Created by Hanny Aly on 5/23/16.
////  Copyright © 2016 Aly LLC. All rights reserved.
////
//
//import Foundation
//
//
//class ProfileModel {
//    
//
//    let defaultNumberOfAlbums = 10
//    let dictionaryRepresentation: [String: AnyObject]
//    let user: UserModel
//    var publicAlbums: [AlbumModel]
//    var newAlbums: [AlbumModel]
//    
//    
//    
//    
//    init(withUser userModel: UserModel) {
//        
//        dictionaryRepresentation = userModel.dictionaryRepresentation
//        user = userModel
//        publicAlbums = [AlbumModel]()
//        newAlbums = [AlbumModel]()
//
//        createAlbums(defaultNumberOfAlbums)
//    }
//    
//    init(withUser userModel: UserModel, withNumberOfAlbums albumsNumber: Int) {
//        
//        dictionaryRepresentation = userModel.dictionaryRepresentation
//        user = userModel
//        publicAlbums = [AlbumModel]()
//        newAlbums = [AlbumModel]()
//
//        createAlbums(albumsNumber)
//    }
//    
//    init(withUser userModel: UserModel, andAlbums albums: [AlbumModel]) {
//        
//        dictionaryRepresentation = userModel.dictionaryRepresentation
//        user = userModel
//        publicAlbums = albums
//        newAlbums = [AlbumModel]()
//
//    }
//    
//    func createAlbums(albumsNumber: Int)  {
//        
//        let albumsModel = TESTFollowFeedModel(withType: .Friends, forNumberOfAlbums: albumsNumber, myAlbums: true)
//        
//        publicAlbums.appendContentsOf(albumsModel.albums)
//    }
//    
//    
//    func deleteImage() -> Bool {
////        user.deleteUserPic()
//        if user.userPic == nil {
//            return true
//        }
//        return false
//    }
//    
//    func albumCount() -> Int {
//       return publicAlbums.count
//    }
//    
//    
//    func albumAtIndex(index: Int) -> AlbumModel {
//        return publicAlbums[index]
//    }
//    
//    
//    
//    
//    func newAlbumAtIndex(index: Int) -> AlbumModel {
//        return newAlbums[index]
//    }
//
//    func newAlbumCount() -> Int {
//        return newAlbums.count
//    }
//    
//    func newAlbum() -> AlbumModel {
//        return newAlbums[0]
//    }
//    
//    func insertNewAlbum(album: AlbumModel) -> Int {
//        
//        publicAlbums.append(album)
//        newAlbums.insert(album, atIndex: 0)
//
//        return publicAlbums.endIndex - 1
//    }
//    
//    
//    
//}
//
