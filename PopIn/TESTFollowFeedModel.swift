//
//  TESTAlbumTableDetails.swift
//  PopIn
//
//  Created by Hanny Aly on 5/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation


class TESTFollowFeedModel: FollowFeedModel {
    
    

//    var albums:[FriendModel]
    
    let defaultNumberOfAlbums = 10
    let defaultNumberOfNewAlbums = 5
    
    
   /*
        Inheritied variables
        albums    = [FriendAlbumModel]()
        newAlbums = [FriendAlbumModel]()
    */
    
    override init(withType model: ModelType) {
        
        super.init(withType: model)
        switch model {
        case .Friends:
            albums = [AlbumModel]()

//            createFriendsAlbums(defaultNumberOfAlbums)
        case .Albums:
            albums = [AlbumModel]()

//            createGroupAlbums()
        case .Groups:
            albums = [AlbumModel]()
        case .Events:
            albums = [AlbumModel]()
        }
    }
    
    init(withType model: ModelType, forNumberOfAlbums numberOfAlbums: Int) {
        
        super.init(withType: model)
        
        switch model {
        case .Friends:
            albums = [AlbumModel]()
        case .Albums:
            albums = [AlbumModel]()
        case .Groups:
            albums = [AlbumModel]()
        case .Events:
            albums = [AlbumModel]()
        }
    }
    
    init(withType model: ModelType, forNumberOfAlbums numberOfAlbums: Int, myAlbums: Bool) {
        
        super.init(withType: model)
        
        switch model {
        case .Friends:
            albums = [AlbumModel]()
        case .Albums:
            albums = [AlbumModel]()
        case .Groups:
            albums = [AlbumModel]()
        case .Events:
            albums = [AlbumModel]()
        }
        
//        if myAlbums {
//            createMyAlbums(numberOfAlbums)
//        }
        
    }
    
    
    
//    
//    
//    
//    override func refreshFeedWithCompletionBlock(completionClosure: (albumResults :[AlbumModel]) ->(), numbersOfResultsToReturn numResults: Int ) {
//        
//        print("refreshFeedWithCompletionBlock")
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
//            sleep(2)
//
//            dispatch_async(dispatch_get_main_queue()) {
//                
//                self.createFriendsAlbums(self.defaultNumberOfAlbums)
//                
//                completionClosure(albumResults: self.albums)
//                
//            }
//        }
//    }
//
////    
////    - (void)refreshFeedWithCompletionBlock(completionClosure: (void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults
////    {
////    // only one fetch at a time
////    if (_refreshFeedInProgress) {
////    return;
////    
////    } else {
////    _refreshFeedInProgress = YES;
////    _currentPage = 0;
////    
////    // FIXME: blow away any other requests in progress
////    [self fetchPageWithCompletionBlock:^(NSArray *newPhotos) {
////    if (block) {
////    block(newPhotos);
////    }
////    _refreshFeedInProgress = NO;
////    } numResultsToReturn:numResults replaceData:YES];
////    }
////    }
////    
//    
//    
//    
//    
////    func newAlbumsIds() -> [String] {
////        return newAlbums.
////    }
//    
//    
//    private  func randomTimerLimit() -> Int {
//        let timeLimit = Int(arc4random_uniform(UInt32(10)))
//        if timeLimit < 4 {
//            return 4
//        }
//        return timeLimit
//    }
//    
//    
//
//    
//    private func isNewMedia() -> Bool {
//        return Bool(Int(arc4random_uniform(UInt32(2))))
//    }
//    
//
//    private let mediaContent = ["IMG_2243.jpg", "IMG_2244.jpg", "IMG_2245.jpg", "IMG_2246.jpg", "IMG_2247.jpg", "IMG_2248.jpg", "IMG_2249.jpg"]
//
//    private func randomMediaContentStrings() -> String {
//        return mediaContent[Int(arc4random_uniform(UInt32(mediaContent.count)))]
//    }
//    
//    
//    // Returns fake pictures
//    private func randomMediaContent() -> ( [MediaModel], Bool, Int) {
//
//        var newMediaExists = isNewMedia()
//        var returnValueMediaExists = false
//
//        var newMediaExistsAtIndex = 0
//        let numberOfContent = Int(arc4random_uniform(UInt32(10)))
//        
//        var contentList = [MediaModel]()
//        
//        
//        for _ in 0...numberOfContent {
//            
//            if newMediaExists {
//                
//                contentList.append(MediaModel(withImage: randomMediaContentStrings(),
//                                              andTimeLimit: randomTimerLimit(),
//                                              isNew: newMediaExists))
//                returnValueMediaExists = true
//                
//            } else {
//                contentList.append(MediaModel(withImage: randomMediaContentStrings(),
//                                              andTimeLimit: randomTimerLimit(),
//                                              isNew: newMediaExists))
//                
//                newMediaExists = isNewMedia()
//                newMediaExistsAtIndex += 1
//            }
//        }
//        
//        return (contentList, returnValueMediaExists, newMediaExistsAtIndex)
//    }
//    
//    
//    
//    
//    private let albumTitles = ["In the River", "On the Train", "Very instrumental", "On the float",
//                              "Off to California", "What whaaaat!!!",
//                             "Kicked out the train car", "Sunday funday", "Huh huh"]
//    
//    
//    private  func randomAlbumTitle() -> String {
//        return albumTitles[Int(arc4random_uniform(UInt32(albumTitles.count)))]
//    }
//    
//    
//    private let coverPhotos = ["album1.png", "album2.jpg", "album3.jpg", "album4.jpg", "album5.jpg"]
//
//    
//
//    
//    private  func randomCoverPhoto() -> String {
//        return coverPhotos[Int(arc4random_uniform(UInt32(coverPhotos.count)))]
//    }
//    
//    
//    private  func randomId() -> String {
//        return String(Int(arc4random_uniform(UInt32(100000))))
//    }
//    
//    
//    
//    //  predicate example
//    private func useridIsUnique(id: Int) -> Bool {
//        
//        let useridIndex = albums.indexOf { (albumModel: AlbumModel) -> Bool in
//       
//            if albumModel.id == id {
//                return true
//            }
//            return false
//        }
//        
//        if useridIndex == nil {
//            return true
//        }
//        return false
//    }
//    
//    
//    private func confirmedUniqueId() -> Int {
//        
//        var randomId = randomUserid()
//        
//        while !useridIsUnique(randomId) {
//            randomId = randomUserid()
//        }
//        return randomId
//    }
//    
//    
//    private func randomUserid() -> String {
//        return String(Int(arc4random_uniform(UInt32(100000))))
//    }
//    
//    
//    
//    
//    
//    
//    
//    private let timeEnding = ["s", "d", "w", "m"]
//    
//    private func randomTimeEnding() -> String {
//        return timeEnding[Int(arc4random_uniform(UInt32(timeEnding.count)))]
//    }
//    
//    private func randomTime() -> String {
//        return String(Int(arc4random_uniform(UInt32(20))))
//    }
//    
//    
//    
//    func userCreatedAlbum() {
//        let userAlbum = createRandomAlbum()
//        albums.append(userAlbum)
//    }
//    
//    private func createFriendsAlbums(numberOfAlbums: Int) {
//        
//        albums    = [FriendAlbumModel]()
//        newAlbums = [FriendAlbumModel]()
//        
//    
//        for _ in 0..<numberOfAlbums {
//            
//            let userAlbum = createRandomAlbum()
//            albums.append(userAlbum)
//            print("Appending album with: \(userAlbum.mediaCount!) images")
//            if userAlbum.hasNewContent {
//                print("New Album at index: \(newAlbums.count) with new image starting at index: \(userAlbum.newMediaIndex!)")
//                newAlbums.append(userAlbum)
//                
//            }
//        }
//    }
//    
//    
//    func dictionaryRepOfMediaContent(mediaContent: [String] ) -> [String: AnyObject] {
//        return ["mediaContent": mediaContent]
//    }
//
//    
//    
//    func createRandomAlbum() -> FriendAlbumModel {
//        print("TESTFollowFeedModel init")
//
//        let user = TESTFullAppModel(numberOfUsers: 1).firstUser()
//        
//        let (mediaContent, newMediaExists, newMediaIndex) = randomMediaContent()
//        
//        let dictInfo = ["mediaContent": mediaContent, "hasNewContent": newMediaExists]
//        
//        let album = FriendAlbumModel(withAlbumInfo: dictInfo as! [String : AnyObject])
//        
//        if newMediaExists { album.newMediaIndex = newMediaIndex }
//        
//        album.mediaCount = album.mediaContent.count
//        
//        album.id = confirmedUniqueId()
//        album.ownerProfile = user
//        album.coverPhoto = randomCoverPhoto()
//        album.title = randomAlbumTitle()
//        album.time = randomTime() + randomTimeEnding()
//
//        return album
//    }
//    
//    
//    
//    func createMyAlbums(numberOfAlbums: Int) {
//        createFriendsAlbums(numberOfAlbums)
//        
//        albums.sortInPlace({ (album1, album2) -> Bool in
//            
//            if album1.time < album2.time {
//                return true
//            }
//            return false
//        })
//        
//        newAlbums.sortInPlace({ (album1, album2) -> Bool in
//            
//            if album1.time < album2.time {
//                return true
//            }
//            return false
//        })
//        
//        
//    }
//    
//    
//    func createFriendsAlbums() {
//        
//        albums    = [FriendAlbumModel]()
//        newAlbums = [FriendAlbumModel]()
////        
////        let album1 = FriendAlbumModel()
////        
////        var dict = ["userid"  : "feij3fs",
////                    "username": "username1",
////                    "fullname": "John Smith",
////                    "userTestPic" : "boy1.jpg" ]
////        
////
////        album1.id = "1111"
////        album1.ownerProfile = UserModel(withUser: dict)
////        
////        album1.title = "San Fran Home of the brave and let run them freedom, andfiefefefhwhfewiofefwhfihwefeihfwifiewfeinwfi done"
//////        album1.coverPhotoURL = NSURL
////        album1.coverPhoto = "album1.png"
////        album1.time = "3s"
////        album1.mediaCount = 5
////        
////        albums.append(album1)
////        newAlbums.append(album1)
////        
////        
////        let album2 = FriendAlbumModel()
////        
////        
////        dict = ["userid": "hfjd9sjs93",
////                    "username": "username2",
////                    "fullname": "Jane Smith",
////                    "userTestPic" : "girl1.jpg" ]
////
////        album2.id = "2222"
////
////        album2.ownerProfile = UserModel(withUser: dict)
////
////        album2.title = "Beach"
////        album2.coverPhoto = "album2.jpg"
////        album2.time = "4 min"
////        album2.mediaCount = 5
////        albums.append(album2)
////        
////        let album3 = FriendAlbumModel()
////        
////        dict = ["userid": "hfjd9sjs93",
////                "username": "username3",
////                "fullname": "John Doe",
////                "userTestPic" : "boy2.jpg" ]
////
////        album3.id = "3333"
////        album3.ownerProfile = UserModel(withUser: dict)
////        
////        album3.title = "Home"
////        album3.coverPhoto = "album3.jpg"
////        album3.time = "1 hr ago"
////        album3.mediaCount = 5
////        
////        albums.append(album3)
////        newAlbums.append(album3)
////
////        
////        let album4 = FriendAlbumModel()
////
////        
////        
////        dict = ["userid": "hfjd9sjs93",
////                "username": "username4",
////                "fullname": "Jane Doe",
////                "userTestPic" : "girl2.jpg" ]
////
////        
////        album4.id = "4444"
////        album4.ownerProfile = UserModel(withUser: dict)
////
////        album4.title = "Colorado"
////        album4.coverPhoto = "album4.jpg"
////        album4.time = "1 hr ago"
////        album4.mediaCount = 5
////        albums.append(album4)
////
////        
////        let album5 = FriendAlbumModel()
////
////        
////        dict = ["userid": "hfjd9sjs93",
////                "username": "username5",
////                "fullname": "Thomas Doe",
////                "userTestPic" : "boy3.jpg" ]
////
////        
////        album5.id = "5555"
////
////        album5.ownerProfile = UserModel(withUser: dict)
////
////        album5.title = "Disney"
////        album5.coverPhoto = "album5.jpg"
////        album5.time = "2 hr ago"
////        album5.mediaCount = 5
////        albums.append(album5)
//        
//    }
//    
//    
//    
//    
//    func createGroupAlbums() {
//        
//        albums = [GroupAlbumModel]()
//        
////        let album1 = GroupAlbumModel()
////        
////        let dict = ["userid": "hfjd9sjs93",
////                    "username": "username1",
////                    "fullname": "John Smith"]
////        
////        
////        album1.ownerProfile = UserModel(withUser: dict)
////        
////        album1.id = "1111"
////        album1.title = "Cool Group"
////        album1.coverPhoto = "somephoto.url"
////        album1.time = "3s"
////        album1.mediaCount = 5
////        albums.append(album1)
////        
////        let album2 = GroupAlbumModel()
////        
////        let dict2 = ["userid": "hfjd9sjs93",
////                    "username": "username1",
////                    "fullname": "John Smith"]
////        
////        album2.id = "2222"
////        album2.ownerProfile = UserModel(withUser: dict2)
////        album2.title = "Nerd Group"
////        album2.coverPhoto = "somephoto.url"
////        album2.time = "4 min"
////        album2.mediaCount = 5
////        albums.append(album2)
////        
////        let album3 = GroupAlbumModel()
////        
////        let dict3 = ["userid": "hfjd9sjs93",
////                    "username": "username1",
////                    "fullname": "John Smith"]
////        
////        
////        album3.ownerProfile = UserModel(withUser: dict3)
////        album3.id = "3333"
////
////        album3.title = "Gym Group"
////        album3.coverPhoto = "somephoto.url"
////        album3.time = "1 hr ago"
////        album3.mediaCount = 5
////        albums.append(album3)
////        
////        
////        let album4 = GroupAlbumModel()
////        
////        let dict4 = ["userid": "hfjd9sjs93",
////                    "username": "username1",
////                    "fullname": "John Smith"]
////        
////        
////        album4.ownerProfile = UserModel(withUser: dict4)
////
////        album4.id = "4444"
////
////        album4.title = "BFFs"
////        album4.coverPhoto = "somephoto.url"
////        album4.time = "1 hr ago"
////        album4.mediaCount = 5
////        albums.append(album4)
////        
////        
////        let album5 = GroupAlbumModel()
////        
////        let dict5 = ["userid": "hfjd9sjs93",
////                    "username": "username1",
////                    "fullname": "John Smith"]
////        
////        
////        album5.ownerProfile = UserModel(withUser: dict5)
////        album5.id = "5555"
////
////        album5.title = "All together now"
////        album5.coverPhoto = "somephoto.url"
////        album5.time = "2 hr ago"
////        album5.mediaCount = 5
////        albums.append(album5)
//        
//    }
}