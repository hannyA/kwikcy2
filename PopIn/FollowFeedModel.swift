//
//  FollowFeedModel.swift
//  PopIn
//
//  Created by Hanny Aly on 5/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation

class FollowFeedModel {

    enum ModelType {
        case Friends
        case Albums
        case Groups
        case Events
    }
//    var newAlbumIds:[String]

    var newAlbums:[AlbumModel]
    var albums:[AlbumModel]

    
    
    
    init(withType model: ModelType) {
        
//        newAlbumIds = [String]()
        
        switch model {
        case .Friends:
            newAlbums = [AlbumModel]()
            albums = [AlbumModel]()
        case .Albums:
            newAlbums = [AlbumModel]()
            albums = [AlbumModel]()
        case .Groups:
            newAlbums = [AlbumModel]()
            albums = [AlbumModel]()
        case .Events:
            newAlbums = [AlbumModel]()
            albums = [AlbumModel]()
        }
    }
    
    
    func refreshFeedWithCompletionBlock(completionClosure: (albumResults :[AlbumModel]) ->(), numbersOfResultsToReturn numResults: Int ) {
        
    
    }

    func clearData() {
        albums.removeAll()
        newAlbums.removeAll()
    }
    
    
    
    //MARK: New Album Methods

    
    func hasNewAlbums() -> Bool {
        return !newAlbums.isEmpty
    }
    
    func numberOfNewAlbums() -> Int {
        return newAlbums.count
    }
    
    func deleteNewAlbum(album: AlbumModel) {
        if let index = indexOfNewAlbumModel(album) {
            newAlbums.removeAtIndex(index)
        }
    }
    
    func removeNewAlbumAtIndex(index: Int) {
        newAlbums.removeAtIndex(index)
        if newAlbums.isEmpty {
            
        }
    }
    
//    WORKS!
//    let index = selectdFriends.indexOf({ (userModel: UserModel) -> Bool in
//        
//        if userModel.username == friendNode.userModel.username {
//            return true
//            
//        }
//        return false
//    })
//
    
    func indexOfNewAlbumModel(album: AlbumModel) -> Int? {
        
        return newAlbums.indexOf({ (someAlbum: AlbumModel) -> Bool in
            
            if someAlbum.id == album.id {
                return true
            }
            return false
        })
    }
    
    
    
    func newAlbumAtIndex(index: Int) -> AlbumModel? {
        if newAlbums.isEmpty {
            return nil
        }
        return newAlbums[index]
    }
    

    
    func IdsOfNewAlbums() -> [String] {
        //["1111", "2222"]
        
        var dict = [String]()
        for album in albums {
            dict.append(album.id!)
        }
        return dict
    }
    
    
    
    
    func hasAlbums() -> Bool {
        return !albums.isEmpty
    }
    
    func totalNumberOfAlbums() -> Int {
        return albums.count
    }
    
    func numberOfAlbumsInFeed() -> Int {
        return albums.count
    }
    
    func albumAtIndex(index: Int) -> AlbumModel? {
        if albums.isEmpty {
            return nil
        }
        return albums[index]
    }
    
    
    
    
    
//    - (NSUInteger)totalNumberOfPhotos;
//    - (NSUInteger)numberOfItemsInFeed;
//    - (PhotoModel *)objectAtIndex:(NSUInteger)index;
//    - (NSInteger)indexOfPhotoModel:(PhotoModel *)photoModel;

    
    
    
    
}