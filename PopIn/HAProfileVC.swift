//
//  HAProfileVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/2/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class HAProfileVC: ASViewController, ASTableDelegate, ASTableDataSource, ProfilePagerControlCellNodeDelegate, MyAlbumCNDelegate, BasicProfileCNDelegate {

    enum TableViewSection {
        case Albums
        case Notifications
    }
    
    let tableNode: ASTableNode
    var profileModel: ProfileModel
    var notificationCount = 5
    var currentTableView: TableViewSection
    var profilePageController: ProfilePagerControlCellNode?
    
    var basicUserCellNode: BasicProfileCellNode?
    
    init() {
        
        let userModel = TESTFullAppModel(numberOfUsers: 1).firstUser()
        profileModel = ProfileModel(withUser: userModel!, withNumberOfAlbums: 6)
        
        tableNode = ASTableNode(style: .Plain)
        currentTableView = .Albums

        super.init(node: tableNode)
        
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = profileModel.user.userName!

        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        tableNode.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        let settingsButton = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(openSettingsVC)
        )
        navigationItem.setRightBarButtonItem(settingsButton, animated: false)
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
        if buttonTag == 1 {
            currentTableView = .Albums
            deleteRowsFromTableViewWithCount(notificationCount, withAnimation: .Fade )
            insertRowsInTableViewWithCount(profileModel.albumCount(), withAnimation: .Fade )
            
        } else {
            currentTableView = .Notifications
            deleteRowsFromTableViewWithCount(profileModel.albumCount(), withAnimation: .Fade)
            insertRowsInTableViewWithCount(notificationCount, withAnimation: .Fade)
        }
    }

    func openSettingsVC() {
        
        let settingsVC = HASettingsRealVC()
     
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem

        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
    func editProfile() {
        let editProfileVC = HAEditProfileVC()
        let navCon = UINavigationController(rootViewController: editProfileVC)
        presentViewController(navCon, animated: true, completion: nil)
    }
    
    
    
    //MARK: - ASTableDataSource methods
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return nil
        } else {
            return "My Albums"
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if section == 1 {
            let headerView = view as! UITableViewHeaderFooterView
            headerView.backgroundView?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
            
            headerView.textLabel?.textAlignment = .Center
        }
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
         return 2
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else  {
            if currentTableView == .Albums {

                return profileModel.albumCount()
            } else  {
                return notificationCount
            }
        }
    }
    
    
    
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        if indexPath.section == 0 {
            
            return {() -> ASCellNode in
                self.basicUserCellNode = BasicProfileCellNode(withProfileModel: self.profileModel, loggedInUser: true)
                self.basicUserCellNode!.delegate = self
                self.basicUserCellNode!.selectionStyle = .None
                return self.basicUserCellNode!
            }
            
        } else { // Section 2
            
            print("profileModel count \(profileModel.albumCount())")
            // If albums exist
            let album = profileModel.albumAtIndex(indexPath.row)
            
            return {() -> ASCellNode in
                let albumCellNode = MyAlbumCN(withAlbumObject: album, atIndexPath: indexPath)
                albumCellNode.selectionStyle = .None
                albumCellNode.delegate = self
                return albumCellNode
            }
        }
        
        
//        if indexPath.section == 0 {
//            
//            if indexPath.row == 0 {
//                return {() -> ASCellNode in
//                    return BasicProfileCellNode(withProfileModel: self.profileModel, loggedInUser: true)
//                }
//            } else {
//                return {() -> ASCellNode in
//                    self.profilePageController = ProfilePagerControlCellNode()
//                    self.profilePageController!.delegate = self
//                    return self.profilePageController!
//                }
//            }
//        } else { // Section 2
//            
//            
//            if currentTableView == .Albums {
//             
//            
//            
//                // If albums exist
//                let album: AlbumModel = profileModel.albumAtIndex(indexPath.row)
//                
//                // this may be executed on a background thread - it is important to make sure it is thread safe
//                return {() -> ASCellNode in
//                    return AlbumCellNode(withAlbumObject: album)
//                }
//
        
    }
    
    
    func showMoreOptionsForObjectAtIndexPath(indexPath: NSIndexPath) {
        
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
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        print("didSelectRowAtIndexPath: \(indexPath.row)")
        
    }
    
    
    
    
    func showImageOptions() {
        print("showImageOptions")
        
        let alertController = UIAlertController(title: "Profile photo", message: nil, preferredStyle: .ActionSheet)
        
        
        let removeProfilePhotoAction = UIAlertAction(title: "Remove Current Image", style: .Destructive) { (alertAction) in
            self.basicUserCellNode?.removePhoto()
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


