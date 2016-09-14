//
//  FollowFeedModel.swift
//  PopIn
//
//  Created by Hanny Aly on 5/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AWSMobileHubHelper

class FollowFeedModel {

    enum ModelType {
        case Friends
        case Albums
        case Groups
        case Events
    }
    
    var newAlbums:[FriendAlbumModel]
    var albums   :[FriendAlbumModel]  // TODO: Chaange this to viewedAlbums

    
    var refreshingFeedDataInProgress = false
    var fetchingMoreDataInProgress   = false
    
    
    
    init(withType model: ModelType) {
        
        
        switch model {
        case .Friends:
            newAlbums = [FriendAlbumModel]()
            albums = [FriendAlbumModel]()
        case .Albums:
            newAlbums = [FriendAlbumModel]()
            albums = [FriendAlbumModel]()
        case .Groups:
            newAlbums = [FriendAlbumModel]()
            albums = [FriendAlbumModel]()
        case .Events:
            newAlbums = [FriendAlbumModel]()
            albums = [FriendAlbumModel]()
        }
    }
    
    
    func requestPageWithCompletionBlock(completionClosure: (albumResults :[FriendAlbumModel]) ->(), numbersOfResultsToReturn numResults: Int ) {
    
        
        if fetchingMoreDataInProgress {
            return
        }
        
        fetchingMoreDataInProgress = true
        
//        [self fetchPageWithCompletionBlock:block numResultsToReturn:numResults];

    }

    
    

    
    

    func refreshFeedWithCompletionBlock(completionClosure:(indexSetChange: Int, insertSections: [NSIndexPath]?, removeSections: [NSIndexPath]?, reloadSections: [NSIndexPath]?, error: String?) ->(), numbersOfResultsToReturn numResults: Int ) {
    
    
//    func refreshFeedWithCompletionBlock(completionClosure: (addSectionAlbums: [FriendAlbumModel], removeSectionAlbums: [FriendAlbumModel], reloadSectionAlbums: [FriendAlbumModel],
//        
//        addNewSectionAlbums: [FriendAlbumModel], removeNewSectionAlbums: [FriendAlbumModel], reloadNewSectionAlbums: [FriendAlbumModel]
//        , error: String?) ->(), numbersOfResultsToReturn numResults: Int ) {
//        
        print("refreshFeedWithCompletionBlock")

        // only one fetch at a time
        if refreshingFeedDataInProgress {
            return
        }
        
        refreshingFeedDataInProgress = true
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]      = Me.sharedInstance.guid()
        jsonObj[kAcctId]    = Me.sharedInstance.acctId()
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaFriendsAlbums,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            
            self.refreshingFeedDataInProgress = false

            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("refreshFeedWithCompletionBlock - Result: \(result)")
                    
                    
                    var numberOfPreviousSections = 0
                    
                    if !self.newAlbums.isEmpty {
                        numberOfPreviousSections += 1
                    }
                    
                    if !self.albums.isEmpty {
                        numberOfPreviousSections += 1
                    }
                    
                    
                    /*
                     
                        Ways to View
                     
                        This should all be set up in notifications
                        If "dataing save mode" is on
                            Optins will change to: 
                                1) save data on "friends messages"
                                2) Save data on all data
                                    Split into Save data NSUserDefaults:        
                                        a) friends
                                        b) public
                     
                     
                     Use Realm for friends Albus
                     User In-memory Realm for all other albums
                     
                     If saveDataMode == Off {
                     
                        1) Predownload everything
                     } else {
                     
                        2) Click album - Downloadload everything
                            1) Auto open up
                            2) User click again to open
                     
                        3) User clicks album - it opens up to loading screen but user
                     
                     }
                      Every 
                     
                     Design - For every cell ready to be opened
                     
                     */
                    
                    
                    if let response = FollowFeedResponse(response: result) {
                      
                        var insertNewSectionAlbums = [FriendAlbumModel]()
                        var removeNewSectionAlbums = [FriendAlbumModel]()
                        var reloadNewSectionAlbums = [FriendAlbumModel]()
                        var ignoreNewSectionAlbums = [FriendAlbumModel]()

                        
                        var insertSectionAlbums = [FriendAlbumModel]()
                        var removeSectionAlbums = [FriendAlbumModel]()
                        var reloadSectionAlbums = [FriendAlbumModel]()
                        var ignoreSectionAlbums = [FriendAlbumModel]()


                        for serverAlbum in response.albums {
                                                        
                            // New Album Section
                          
                            // This should be a pointer to both newAlbums and albums array
                            // If album exists, in new albums section
                            if let currentNewAlbum = self.filterNewAlbums(serverAlbum).first {
                                
                                print("currentNewAlbum = self.filterNewAlbums")

                                // I beieve currentNewAlbum will be the same as viewedAlbum
                                
                                // If the album also exists in the already viewed section
                                if let _ = self.filterAlbums(serverAlbum).first {
                                    print("filterAlbums(serverAlbum).first")

                                    
                                    // Has new content? Update rows to update time and image
                                    if currentNewAlbum.shouldBeUpdated(serverAlbum) {
                                        print("shouldBeUpdated")

                                        
                                        reloadNewSectionAlbums.append(currentNewAlbum)
                                        reloadSectionAlbums.append(currentNewAlbum)
                                    }
                                        // Time is up? Delete rows
                                    else if currentNewAlbum.shouldBeDeleted() {
                                        print("shouldBeDeleted")

                                        removeNewSectionAlbums.append(currentNewAlbum)
                                        removeSectionAlbums.append(currentNewAlbum)
                                    } else {
                                        print("ignore")

                                        ignoreNewSectionAlbums.append(currentNewAlbum)
                                        ignoreSectionAlbums.append(currentNewAlbum)
                                    }
                                    // ViewedAlbums doesn't have this album, bacause no data viewed
                                } else {
                                    
                                    print("filterAlbums none")

                                    // Has new content? Update rows to update time and image
                                    if currentNewAlbum.shouldBeUpdated(serverAlbum) {
                                        print("filterAlbums none shouldBeUpdated")

                                        reloadNewSectionAlbums.append(currentNewAlbum)
                                    }
                                        // Time is up? Delete rows
                                    else if currentNewAlbum.shouldBeDeleted() {
                                        print("filterAlbums none shouldBeDeleted")

                                        removeNewSectionAlbums.append(currentNewAlbum)
                                    
                                    } else {
                                        print("filterAlbums none ignoreNewSectionAlbums")

                                        ignoreNewSectionAlbums.append(currentNewAlbum)
                                    }
                                    
                                    
                                    if serverAlbum.hasBeenViewed() {
                                        print("filterAlbums none hasBeenViewed")

                                        insertSectionAlbums.append(serverAlbum)
                                    }
                                }
                                
                                
                                // Album does not exist in newAlbums
                            } else if serverAlbum.hasNewContent() {
                                print("album.hasNewContent")

                                insertNewSectionAlbums.append(serverAlbum)

                                // If the album exists in the already viewed section, then update it
                                if let viewedAlbum = self.filterAlbums(serverAlbum).first {
                                    print("album.hasNewContent reloadSectionAlbums")

                                    reloadSectionAlbums.append(viewedAlbum)
                                }
                            }
                            
                            
                            // If album exists in albums list
                            // Content cannot be new and obviosuly can't add
                          
                            else if let currentAlbum = self.filterAlbums(serverAlbum).first {
                                print("currentNewAlbum filterAlbums")

                                // I don't believe this should ever be called
//                                if currentAlbum.shouldBeUpdated(serverAlbum) {
//
//                                    reloadSectionAlbums.append(currentAlbum)
//                                }

                                if currentAlbum.shouldBeDeleted() {
                                    print("album.hasNewContent shouldBeDeleted")

                                    removeSectionAlbums.append(currentAlbum)
                                }
                                // Not in any list so it can't be delted or updated,
                            } else if !serverAlbum.shouldBeDeleted() {
                                
                                print("eles shouldBeDeleted")

                                insertSectionAlbums.append(serverAlbum)
                                
                            } else {
                                
                                print("Send a message to dataabse to delete this album")

                                //TODO: Send a message to dataabse to delete this album
                            }
                        }
                        
                        
                        
                        
                        
                        print("=======  Any current album not in the list should be removed   ======")

                        
                        for album in self.albums {
                            
                            if !self.sectionList(insertSectionAlbums, contains: album)     &&
                                !self.sectionList(reloadSectionAlbums, contains: album) &&
                                !self.sectionList(ignoreSectionAlbums, contains: album) &&
                                !self.sectionList(removeSectionAlbums, contains: album) {
                                
                                print("Not in any section: So append to remove main list")

                                removeSectionAlbums.append(album)
                            }
                        }

                        for album in self.newAlbums {
                            
                            if !self.sectionList(insertNewSectionAlbums, contains: album)     &&
                                !self.sectionList(reloadNewSectionAlbums, contains: album) &&
                                !self.sectionList(ignoreNewSectionAlbums, contains: album) &&
                                !self.sectionList(removeNewSectionAlbums, contains: album) {
                                
                                print("Not in any section: So append to remove new list")

                                removeNewSectionAlbums.append(album)
                            }
                        }

                        
                        
                        let mainSectionIndex = response.hasNewContent ? 1 : 0
                       
                        
                        var addSectionAlbumsIndexPath    = [NSIndexPath]()
                        var removeSectionAlbumsIndexPath = [NSIndexPath]()
                        var reloadSectionAlbumsIndexPath = [NSIndexPath]()
                        
                        
                        // Add the remove Indexpaths
                        for album in removeSectionAlbums {
                            
                            if let index = self.indexOf(album, inList: self.albums) {
                                print("reloadSectionAlbums removeSectionAlbums indexpath")

                                removeSectionAlbumsIndexPath.append(NSIndexPath(forRow: index,
                                                                                inSection: mainSectionIndex))
                            }
                        }
                        
                        for album in removeNewSectionAlbums {
                            
                            if let index = self.indexOf(album, inList: self.newAlbums) {
                                print("reloadSectionAlbums removeNewSectionAlbums indexpath")

                                removeSectionAlbumsIndexPath.append(NSIndexPath(forRow: index,
                                                                                inSection: 0))
                            }
                        }
                        
                        // Delete from albums
                        for album in removeSectionAlbums {
                            if let index = self.indexOf(album, inList: self.albums) {
                                print("reloadSectionAlbums removeSectionAlbums indexpath")
                                self.albums.removeAtIndex(index)
                            }
                        }
                        
                        for album in removeNewSectionAlbums {
                            if let index = self.indexOf(album, inList: self.newAlbums) {
                                print("reloadSectionAlbums removeNewSectionAlbums indexpath")
                                self.newAlbums.removeAtIndex(index)
                            }
                        }

                        
                        
                        
                        
                        // add indexpaths

//                        var row = 0
//                        while row < insertNewSectionAlbums.count {
//                            
//                            
//                            let friendAlbum = insertNewSectionAlbums[row]
//                            self.newAlbums.insert(friendAlbum, atIndex: row)
//
//                            
//                            let indexPath = NSIndexPath(forRow: row, inSection: 0)
//                            addSectionAlbumsIndexPath.append(indexPath)
//                            row += 1
//                        }
                        
                        
                        self.newAlbums.appendContentsOf(insertNewSectionAlbums)
                        self.newAlbums.sortInPlace({ (album1, album2) -> Bool in
                            
                            return album1.newestMediaTime.compare(album2.newestMediaTime) == .OrderedAscending
                        })
                        // Get new rows to Insert
                        for album in insertNewSectionAlbums {
                            
                            if let index = self.indexOf(album, inList: self.newAlbums) {
                                
                                addSectionAlbumsIndexPath.append(NSIndexPath(forRow: index,
                                                                             inSection: 0))
                            }
                        }
                        
                        
                      
                        
                        // Add albums to main content, then sort them out
                        self.albums.appendContentsOf(insertSectionAlbums)
                        self.albums.sortInPlace({ (album1, album2) -> Bool in
                            
                            return album1.ownerProfile.userName < album2.ownerProfile.userName
                        })
                        // Get new rows to Insert
                        for album in insertSectionAlbums {
                            
                            if let index = self.indexOf(album, inList: self.albums) {
                                
                                addSectionAlbumsIndexPath.append(NSIndexPath(forRow: index,
                                                                             inSection: mainSectionIndex))
                            }
                        }
                        
                        
                        
                        
                        
                        
                        // Reload indexpaths
                        for album in reloadSectionAlbums {
                            if let index = self.indexOf(album, inList: self.albums) {
                                print("reloadSectionAlbums appending album indexpath")
                                
                                reloadSectionAlbumsIndexPath.append(NSIndexPath(forRow: index,
                                                                                inSection: mainSectionIndex))
                            }
                        }
                        
                        
                        for album in reloadNewSectionAlbums {
                            
                            if let index = self.indexOf(album, inList: self.newAlbums) {
                                print("reloadSectionAlbums appending newalbum indexpath")
                                
                                reloadSectionAlbumsIndexPath.append(NSIndexPath(forRow: index,
                                                                                inSection: 0))
                            }
                        }
                        
                        
                        
                        var numberOfCurrentSections = 0
                        
                        if !self.newAlbums.isEmpty {
                            numberOfCurrentSections += 1
                        }
                        if !self.albums.isEmpty {
                            numberOfCurrentSections += 1
                        }
                        
                        print("numberOfPreviousSections: \(numberOfPreviousSections)")
                        print("numberOfCurrentSections:  \(numberOfCurrentSections)")
                        
                        let indexSetChange = numberOfCurrentSections - numberOfPreviousSections

                        print("indexSetChange: \(indexSetChange)")

                        
//
//                        if numberOfPreviousSections != numberOfCurrentSections {
//                            
//                            let change = numberOfCurrentSections - numberOfPreviousSections
//                            
//                            let numberOfIndexesToAdd = change > 0 ? change : 0
//                            
//                            
//                            var delete = numberOfPreviousSections - numberOfCurrentSections
//
//                            let numberOfIndexesToRemove = change > 0 ? change : 0
//                            
//                        }
//                        
                        
//                        
//
//                        var numberOfIndexSectionsToInsert = 0
//                        
//                        if newAlbumsIsEmpty && albumsIsEmpty {
//                            
//                            if lastNewAlbumsIsEmpty {
//                                numberOfIndexSectionsToInsert += 1
//                            }
//                            
//                            if lastAlbumsIsEmpty {
//                                numberOfIndexSectionsToInsert += 1
//                            }
//                            
//                        } else if newAlbumsIsEmpty || albumsIsEmpty {
//                            
//                        }
//                        
//                        
//                        
//                        if newAlbumsIsEmpty
//
//                        var deleteFirstSection: Bool?
//                        var insertFirstSection: Bool?
//                        
//                        // removing stuff, but other
//                        if self.newAlbums.isEmpty && !removeNewSectionAlbums.isEmpty {
//                            deleteFirstSection = true
//                        }
//                        
//                        else if self.newAlbums.count == addNewSectionAlbums.count {
//                            insertFirstSection = true
//                        }
//                        
//                        
//                        
//                        
//                        var deleteSecondtSection: Bool?
//                        var insertSecondSection: Bool?
//                        
//                        
//                        // removing stuff, but other
//                        if self.albums.isEmpty && !removeNewSectionAlbums.isEmpty {
//                            deleteSecondtSection = true
//                        }
//                        
//                        if self.newAlbums.count == addNewSectionAlbums.count {
//                            firstSectionTrueForDeleteFalseForInsert = false
//                        }
                        
                        
                        
                        
                        
                        completionClosure(indexSetChange: indexSetChange, insertSections: addSectionAlbumsIndexPath, removeSections: removeSectionAlbumsIndexPath, reloadSections: reloadSectionAlbumsIndexPath, error: nil)
                        
                    } else {
                        completionClosure(indexSetChange: 0, insertSections: nil, removeSections: nil, reloadSections: nil, error: AWSErrorBackend)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                print("download media: failed")
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(indexSetChange: 0, insertSections: nil, removeSections: nil, reloadSections: nil, error: AWSErrorBackend)
                })
            }
        }
    }
    
    
    func sectionList(list: [FriendAlbumModel] , contains album: FriendAlbumModel ) -> Bool {
        
        return list.contains({ (friendAlbumModel) -> Bool in
            
            return album.equalTo(friendAlbumModel)
        })
    }
    
    func indexOf(album: FriendAlbumModel, inList list: [FriendAlbumModel]) -> Int? {
    
        return list.indexOf { (friendModel) -> Bool in
            
            return album.equalTo(friendModel)
        }

    }
    
    
    
    
    
    func filterAlbums(album: FriendAlbumModel) -> [FriendAlbumModel] {
        print("filtering mainalbums")

        return albums.filter({ (friendAlbumModel) -> Bool in
            
            return album.equalTo(friendAlbumModel)
        })
    }
    
    func filterNewAlbums(album: FriendAlbumModel) -> [FriendAlbumModel] {
        
        print("filtering new albums")
        
        return newAlbums.filter({ (friendAlbumModel) -> Bool in
            
            return album.equalTo(friendAlbumModel)
        })
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
    
    func deleteNewAlbum(album: FriendAlbumModel) {
        if let index = indexOfNewAlbumModel(album) {
            newAlbums.removeAtIndex(index)
        }
    }
    
    func removeNewAlbumAtIndex(index: Int) {
        newAlbums.removeAtIndex(index)
        if newAlbums.isEmpty {
            
        }
    }
    
    
    
    func indexOfNewAlbumModel(album: FriendAlbumModel) -> Int? {
        
        return newAlbums.indexOf({ (someAlbum: FriendAlbumModel) -> Bool in
            
            if someAlbum.id == album.id {
                return true
            }
            return false
        })
    }
    
    
    
    func newAlbumAtIndex(index: Int) -> FriendAlbumModel? {
        if newAlbums.isEmpty {
            return nil
        }
        return newAlbums[index]
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
    
    func albumAtIndex(index: Int) -> FriendAlbumModel? {
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