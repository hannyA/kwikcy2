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

class HAProfileVC: ASViewController, ASTableDelegate, ASTableDataSource, ProfilePagerControlCellNodeDelegate, MyAlbumCNDelegate, BasicProfileCNDelegate {

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
    var isLoadingAlbums = true
    var userModel: UserSearchModel
    let downloadManager = HADownloadManager(imageType: .Crop)

    init() {
        
        tableNode = ASTableNode(style: .Plain)
        
        let userInfo = UserSearchModel.BasicInfo(guid: Me.guid()!,
                                                 username: Me.username()!,
                                                 fullname: Me.fullname(),
                                                 verified: Me.verified(),
                                                 blocked: false)
        
        userModel = UserSearchModel(withBasic: userInfo, imageType: .Crop)
        
        albums = MyAlbums()
        
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
        
        
        navigationItem.title = Me.username()
        navigationController?.navigationBar.translucent = false
        
        
        let settingsButton = UIBarButtonItem()
        settingsButton.icon(from: .Ionicon, code: "ios-gear-outline", ofSize: 34)
        settingsButton.tintColor = UIColor.redColor()
        settingsButton.target = self
        settingsButton.action = #selector(openSettingsVC)
        
        navigationItem.setRightBarButtonItem(settingsButton, animated: false)
        
        
        self.downloadManager.setDownloadProfileImages([self.userModel])
        
        self.downloadManager.downloadAllUserThumbImages()
 
        
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

    
    
    func deleteRowsFromTableViewWithCount(count: Int, withAnimation animation: UITableViewRowAnimation) {
        
        var indexPaths = [NSIndexPath]()
        
        for index in 0..<count {
            let indexPath = NSIndexPath(forItem: index, inSection: 1)
            indexPaths.append(indexPath)
        }
        tableNode.view.beginUpdates()
        tableNode.view.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        //        tableNode.view.endUpdates()
    }
    
    
    func insertRowsInTableViewWithCount(count: Int, withAnimation animation: UITableViewRowAnimation) {
        
        var indexPaths = [NSIndexPath]()
        
        for index in 0..<count {
            let indexPath = NSIndexPath(forItem: index, inSection: 1)
            indexPaths.append(indexPath)
        }
        //        tableNode.view.beginUpdates()
        tableNode.view.insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        tableNode.view.endUpdates()
    }
    
    
    
    func switchToPageWithTag(buttonTag: Int) {
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
    }

    
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
                let profileView = BasicProfileCellNode(withProfileModel: self.userModel, loggedInUser: true)

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
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("didSelectRowAtIndexPath section: \(indexPath.section)")
        print("didSelectRowAtIndexPath row    : \(indexPath.row)")
        
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
        let navCon = UINavigationController(rootViewController: editProfileVC)
        presentViewController(navCon, animated: true, completion: nil)
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


