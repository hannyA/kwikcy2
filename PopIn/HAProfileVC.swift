//
//  HAProfileVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/2/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit
import SwiftyDrop
import RealmSwift

class HAProfileVC: ASViewController, ASTableDelegate, ASTableDataSource, //ProfilePagerControlCellNodeDelegate, 
MyAlbumCNDelegate, BasicProfileCNDelegate, HAAlbumDisplayVCDelegate, HAEditProfileVCDelegate {

    enum TableViewSection {
        case Albums
        case Notifications
    }
    
    let tableNode: ASTableNode

//    var currentTableView: TableViewSection
//    var profilePageController: ProfilePagerControlCellNode?
//    var basicUserCellNode: BasicProfileCellNode?
//    var profileView: HAProfileDisplayView
    
    var albums: MyAlbums
//    var albums: My
    var isLoadingAlbums = false
    var userModel: UserSearchModel?
    let downloadManager = HADownloadManager(imageType: .Crop)

    init() {
        
        albums = MyAlbums.sharedInstance

        tableNode = ASTableNode(style: .Plain)
        
        super.init(node: tableNode)
        
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        super.loadView()
        
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        tableNode.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HAProfileVC viewDidLoad")
        
        
        let userInfo = UserSearchModel.BasicInfo(guid: Me.guid()!,
                                                 username: Me.username()!,
                                                 fullname: Me.fullname(),
                                                 verified: Me.verified(),
                                                 blocked: false)
        
        userModel = UserSearchModel(withBasic: userInfo, imageType: .Crop)
        
        
        
        navigationItem.title = Me.username()
        navigationController?.navigationBar.translucent = false
        
        
        let settingsButton = UIBarButtonItem()
        settingsButton.icon(from: .Ionicon, code: "ios-gear-outline", ofSize: 34)
        settingsButton.tintColor = UIColor.redColor()
        settingsButton.target = self
        settingsButton.action = #selector(openSettingsVC)
        
        navigationItem.setRightBarButtonItem(settingsButton, animated: false)
        
        
        // Downloads the users profile image
        self.downloadManager.setDownloadProfileImages([self.userModel!])
        self.downloadManager.downloadAllUserThumbImages()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if albums.shouldUpdateTable {
            updateAlbums()
        } else if !isLoadingAlbums && !albums.isInitialized {
            
            isLoadingAlbums = true
            
            self.tableNode.view.reloadSections(NSIndexSet(index: 1),
                                               withRowAnimation: .None)
            
            albums.load { (success) in
                
                print("albums.load done")
                self.isLoadingAlbums = false
                
                if success {
                    print("success")
                } else {
                    Drop.down("Couldn't get your albums \(randomUpsetEmoji())",
                        state: .Error ,
                        duration: 4.0,
                        action: nil)
                }
                
                self.tableNode.view.reloadSections(NSIndexSet(index: 1),
                    withRowAnimation: .None)
            }
        }
    }
    
    func updateAlbums() {
        
        albums.shouldUpdateTable = false
        self.tableNode.view.reloadSections(NSIndexSet(index: 1),
                                           withRowAnimation: .None)
    }
    
    
//    func deleteRowsFromTableViewWithCount(count: Int, withAnimation animation: UITableViewRowAnimation) {
//        
//        var indexPaths = [NSIndexPath]()
//        
//        for index in 0..<count {
//            let indexPath = NSIndexPath(forItem: index, inSection: 1)
//            indexPaths.append(indexPath)
//        }
//        tableNode.view.beginUpdates()
//        tableNode.view.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
//        //        tableNode.view.endUpdates()
//    }
//
//    func insertRowsInTableViewWithCount(count: Int, withAnimation animation: UITableViewRowAnimation) {
//        
//        var indexPaths = [NSIndexPath]()
//        
//        for index in 0..<count {
//            let indexPath = NSIndexPath(forItem: index, inSection: 1)
//            indexPaths.append(indexPath)
//        }
//        //        tableNode.view.beginUpdates()
//        tableNode.view.insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
//        tableNode.view.endUpdates()
//    }
    
    
//    func switchToPageWithTag(buttonTag: Int) {
//        if buttonTag == 1 {
//            currentTableView = .Albums
//            deleteRowsFromTableViewWithCount(notificationCount, withAnimation: .Fade )
//            insertRowsInTableViewWithCount(profileModel.albumCount(), withAnimation: .Fade )
//            
//        } else {
//            currentTableView = .Notifications
//            deleteRowsFromTableViewWithCount(profileModel.albumCount(), withAnimation: .Fade)
//            insertRowsInTableViewWithCount(notificationCount, withAnimation: .Fade)
//        }
//    }

    
    //MARK: - ASTableDataSource methods
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("titleForHeaderInSection: \(section)")
        if section == 0 {
            return nil
        }
        return "My Albums"
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
        
        headerView.textLabel?.textAlignment = .Center
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return albums.oldCount() > 0 ? albums.oldCount(): 1
    }
    
    
    
//    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        if indexPath.section == 0 {
            
            return {() -> ASCellNode in
                let profileView = BasicProfileCellNode(withProfileModel: self.userModel!, loggedInUser: true)

                profileView.delegate = self
                profileView.selectionStyle = .None
                profileView.friendCount
                return profileView
            }
        }
        
        if isLoadingAlbums && indexPath.row == albums.oldCount() {
            return {() -> ASCellNode in
                let cellNode = HALargeLoadingCN()
                cellNode.selectionStyle = .None
                return cellNode
            }
        } else if albums.oldCount() == 0 {
            
            return {() -> ASCellNode in
                let albumCellNode = SimpleCellNode(withMessage: "No Albums")
                albumCellNode.selectionStyle = .None
                albumCellNode.userInteractionEnabled = false
                return albumCellNode
            }
        }
        
        let album = albums.oldAlbumAtIndex(indexPath.row)
        return {() -> ASCellNode in
            let albumCellNode = MyAlbumCN(withAlbumObject: album,
                                          isSelectable: false,
                                          hasTopDivider: indexPath.row == 0 ? false: true )
            albumCellNode.selectionStyle = .None
            albumCellNode.delegate = self
            return albumCellNode
        }
    }
    
    
    
    
    var lastSelectedIndexPath: NSIndexPath?
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        print("didSelectRowAtIndexPath section: \(indexPath.section)")
        print("didSelectRowAtIndexPath row    : \(indexPath.row)")
        

        
        if indexPath.section == 1 {
            
            lastSelectedIndexPath = indexPath
         
            if albums.oldCount() > 0 {

                
                let cellNode = tableNode.view.nodeForRowAtIndexPath(indexPath) as! MyAlbumCN
                let album = cellNode.album

                
                // If we have all the data in our model
                if album.hasEnoughContentToPresent() {
                    print("hasEnoughContentToPresent")

                    
                    print("New album has \(album.mediaCount()) images")

                    print("==================================================")
                    print("================   New Selection  ================")
                    print("==================================================")
                    
                    setupShow(album)
               
                } else {
                    print("We need some more images to present")

                    
                    cellNode.showSpinningWheel()
                    
                    album.downloadMediaContent(onCompletion: { (didGetNewContent, errorMessage) in
                        
                        cellNode.hideSpinningWheel()
                        
                        if self.lastSelectedIndexPath == indexPath {
                            if didGetNewContent {
                                self.setupShow(album)
                            } else {
                                
                                Drop.down(errorMessage ?? AWSErrorBackend,
                                    state: .Error ,
                                    duration: 4.0,
                                    action: nil)
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    func removeNewAlbum(album: AlbumModel) {
        // Do not implement
    }

    
    
    func setupShow(album: AlbumModel) {
        
        let displayAlbumVC = HAAlbumDisplayVC(userAlbum: album)
        displayAlbumVC.delegate = self
        presentViewController(displayAlbumVC, animated: false, completion: nil)
    }
    
    
    
    func openSettingsVC() {
        let settingsVC = HASettingsRealVC()
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
    func showFriends() {
        print("showFriends")
        let friendsVC = HAEditUsersVC()
        
        let navCon = UINavigationController(rootViewController: friendsVC)
        presentViewController(navCon, animated: true, completion: nil)
    }

    func editProfile() {
        let editProfileVC = HAEditProfileVC()
        editProfileVC.delegate = self
        let navCon = UINavigationController(rootViewController: editProfileVC)
        presentViewController(navCon, animated: true, completion: nil)
    }
    
    
    func updateProfile() {
        self.tableNode.view.reloadSections(NSIndexSet(index: 0),
                                           withRowAnimation: .None)
    }
    
    
    
    func showOptionsForAlbum(album: AlbumModel) {
        
        print("showMoreOptions")
        
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .ActionSheet)
        
        let deleteAlbumAction = UIAlertAction(title: "Delete Album", style: .Destructive) { (alertAction) in

        }
        alertController.addAction(deleteAlbumAction)
        

        
        let editUsersAction = UIAlertAction(title: "Edit Users", style: .Default) { (defaultAction) in
//            let album = self.profileModel.albumAtIndex(indexPath.row)
            
//            let albumUploadVC = AlbumUploadVC(withPhoto: <#T##UIImage#>)
//            //        albumSelectionVC.delegate = self
//            
//            self.navigationController?.pushViewController(albumUploadVC, animated: true)
            
        }
        alertController.addAction(editUsersAction)
        
        let editMediaContent = UIAlertAction(title: "Edit Content", style: .Default) { (defaultAction) in
          
//            let album = self.profileModel.albumAtIndex(indexPath.row)
        }
        alertController.addAction(editMediaContent)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (canceled) in
            print("Canceled pressed")
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true) {
        }
    }
    
    
    // Delegate method for NewAlbumVC ?
    func uploadAlbum(album: AlbumModel) { }

    
    func retryUploadingMediaToAlbum(album: AlbumModel) {
        
        album.retryUploadingLastMedia { (successful, errorMessage) in
            
            if !successful {
                
                Drop.down(errorMessage ?? AWSErrorBackend,
                    state: .Error ,
                    duration: 4.0,
                    action: nil)
            }
            NSNotificationCenter.defaultCenter().postNotificationName(kAlbumMediaUploadNotification,
                                                                    object: album,
                                                                    userInfo: ["success": successful])
        }
//        
//        let imageRep = UIImageJPEGRepresentation(newPhoto, kCompression.Worst.rawValue)
//        
//        let imageSize = CGFloat( imageRep!.length)
//        print("imageSize: \(imageSize / 1024) KB")
//        
//        
//        let imageBase64 = imageRep?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
//        
//        
//        
//        
//        
//        albums.uploadMedia(imageBase64!, type: MediaType.Photo.rawValue, timelimit: 5, to: selectedAlbumModel) { (successful, errorMessage) in
//            
//            if !successful {
//                
//                Drop.down(errorMessage!,
//                          state: .Error ,
//                          duration: 4.0,
//                          action: nil)
//            }
//            
//            
//            for album in self.selectedAlbumModel {
//                NSNotificationCenter.defaultCenter().postNotificationName(kAlbumMediaUploadNotification,
//                                                                          object: album,
//                                                                          userInfo: ["success": successful])
//            }
//        }
    }
    
    
    
    func showImageOptions() {
        print("showImageOptions")
        
        let alertController = UIAlertController(title: "Profile photo", message: nil, preferredStyle: .ActionSheet)
        
        
        let removeProfilePhotoAction = UIAlertAction(title: "Remove Current Image", style: .Destructive) { (alertAction) in
//            self.basicUserCellNode?.removePhoto()
        }
        alertController.addAction(removeProfilePhotoAction)
        
        let importFacebook = UIAlertAction(title: "Import from Facebook", style: .Default) { (defaultAction) in
            print("importFacebook pressed")
        }
        alertController.addAction(importFacebook)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default) { (defaultAction) in
            print("takePhotoAction pressed")
        }
        alertController.addAction(takePhotoAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (canceled) in
            print("Canceled pressed")
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true) { }
    }
    
    
    
    func importImageFromFacebook() {
        print("importImageFromFacebook")
    }
    
    func openCamera() {
        print("openCamera")
    }
    
    func removePhoto() {
        
    }
    
    
    
    
}


