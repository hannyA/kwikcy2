//
//  AlbumUploadVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/10/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit
import AWSMobileHubHelper
import SwiftyDrop


let DefaultTimeLimit = 10

/*
 *  View Controller that shows the list of albums that we can choose to add the photo/video
 *  Also has a "Create New Album" button on the bottom of the view
 */

class AlbumUploadVC: ASViewController, ASTableDelegate, ASTableDataSource,
MyAlbumCNDelegate, AlbumUploadDisplayViewDelegate, NewAlbumVCDelegate {
    

    var albums: MyAlbums
    let albumTableNodeDisplay: AlbumUploadDisplayView
    var newPhoto: UIImage
    var isLoadingAlbums = true
    
    var selectedAlbumModel = [UserAlbumModel]()
    
    init(withPhoto photo: UIImage) {

        newPhoto = photo
        albumTableNodeDisplay = AlbumUploadDisplayView()
        
        albums = MyAlbums.sharedInstance
        
        super.init(node: albumTableNodeDisplay)
        
        albumTableNodeDisplay.tableNode.dataSource = self
        albumTableNodeDisplay.tableNode.delegate = self
        
        albumTableNodeDisplay.delegate = self
        title = "My Albums"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTableNodeDisplay.tableNode.view.allowsSelection = true
        albumTableNodeDisplay.tableNode.view.separatorStyle = .None
        
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
            self.albumTableNodeDisplay.tableNode.view.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("AlbumUploadVC viewWillAppear")

        navigationController?.navigationBarHidden = false
    }
    
    /*
     *  Gets called one of 2 ways. Either User,
     *
     *  1)  pushes back button effectively canceling
     *  2)  User calls uploadMediaToSelectedAlbums
     */
    deinit {
        print("AlbumUpload deinit")
        albums.clearNewAlbums()
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    
    //MARK: NewAlbum Delegate methods
    
    func presentNewAlbumVC() {
        
        let newAlbumVC = NewAlbumVC()
        newAlbumVC.delegate = self
        let newAlbumNavCon = UINavigationController(rootViewController: newAlbumVC)
        newAlbumNavCon.modalTransitionStyle  = .CoverVertical
        
        presentViewController(newAlbumNavCon, animated: true, completion: nil)
    }
    
    
    
    func dismissVC() {
        print("AlbumUploadVC dismissVC")
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    enum MediaType: String {
        case Video = "video"
        case Photo = "photo"
        case Gif   = "gif"
    }
    
    
    /*
     *  This function will move the new albums into the oldalbums list
     */
    
    func uploadMediaToSelectedAlbums() {
       
        albumTableNodeDisplay.buttonsDisplay.disableDoneButton()
        print("Lets update all new albums with the new media content")

        
        let imageRep = UIImageJPEGRepresentation(newPhoto, kCompression.Worst.rawValue)
        
        let imageSize = CGFloat( imageRep!.length)
        print("imageSize: \(imageSize / 1024) KB")
        
        
        let imageBase64 = imageRep?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        
        albums.uploadMedia(imageBase64!, type: MediaType.Photo.rawValue, timelimit: DefaultTimeLimit, to: selectedAlbumModel) { (successful, errorMessage) in
            
            if !successful {
                
                Drop.down(errorMessage!,
                          state: .Error ,
                          duration: 4.0,
                          action: nil)
            }
            
            for album in self.selectedAlbumModel {
                NSNotificationCenter.defaultCenter().postNotificationName(kAlbumMediaUploadNotification,
                                                                          object: album,
                                                                          userInfo: ["success": successful])
            }       
        }
        
//        let vc = tabBarController?.selectedViewController as! UINavigationController
//        tabBarController?.selectedIndex = 4
//        vc.popToRootViewControllerAnimated(false)
        
        tabBarController?.selectedIndex = 4
        (tabBarController?.viewControllers![0] as! UINavigationController).popToRootViewControllerAnimated(false)
    }
    
    
    //    // We don't implement this here, WHy is it here. Cause I'm too lazy to make this optional
    func retryUploadingMediaToAlbum(album: UserAlbumModel) {}

    
    //TODO: Chnage this, don't create an album on server that may not be used or unselected
    //
    func createNewAlbum(newAlbum: UserAlbumModel) {
        
        albumTableNodeDisplay.tableNode.view.beginUpdates()

       
        if albums.bothEmpty() {  // Delete "No Albums" row
            albumTableNodeDisplay.tableNode.view.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)],
                                                                        withRowAnimation: .None)
        } else if albums.onlyOneFilled() && !albums.oldEmpty() {
            albumTableNodeDisplay.tableNode.view.insertSections(NSIndexSet(index: 0),
                                                                withRowAnimation: .Top)
        }
        
        let _ = albums.insertNewAlbum(newAlbum)
        
        albumTableNodeDisplay.tableNode.view.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)],
                                                                    withRowAnimation: .Top)
        albumTableNodeDisplay.tableNode.view.endUpdates()
        
        print("end updates")

        uploadAlbum(newAlbum)
    }
    
    
    
    func uploadAlbum(newAlbum: UserAlbumModel) {
        print("will uploadAlbum")
     
        newAlbum.createAlbum { (successful) in
            print("will newAlbum.uploadAlbum")
         
            NSNotificationCenter.defaultCenter().postNotificationName(kAlbumCreateNotification,
                object: newAlbum,
                userInfo: ["success": successful])
            
            if successful {
                print("will newAlbum.uploadAlbum successful")
//                for albumCN in albumsCellNodes {
//                    
//                    self.selectedAlbumModel.append(albumCN.album)
//                    albumCN.userSelected(true)
//                    albumCN.uploadSuccessful(true)
//                    newAlbum.insertPhotoImage(newPhoto)
//                }
            } else {
                print("will newAlbum.uploadAlbum failed")
//                for albumCN in albumsCellNodes {
//                    albumCN.userSelected(false)
//                    albumCN.uploadSuccessful(false)
//                }
                Drop.down("Couldn't create your album \(randomUpsetEmoji())",
                          state: .Error ,
                          duration: 3.0,
                          action: nil)
            }
        }
    }
    
    
    
    // Helper
    
//    func findCellNodesInList(list: [MyAlbumCN], containing album: AlbumModel) -> [MyAlbumCN] {
//        
//        return list.filter({ (albumCN: MyAlbumCN) -> Bool in
//            if albumCN.album === album {
//                return true
//            }
//            return false
//        })
//    }
//    
//    
//    func findCellNodesContaining(album: AlbumModel) -> [MyAlbumCN] {
//        
//        var cellNodes = findCellNodesInList(oldAlbumsCellNodesList, containing: album)
//        let newCellNodes = findCellNodesInList(newAlbumsCellNodesList, containing: album)
//        
//        cellNodes.appendContentsOf(newCellNodes)
//        return cellNodes
//    }
    
    
    
    
    
    //MARK: - ASTableDataSource methods
    /*
     *  New albums section and original albums section
     */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return albums.bothFilled() ? 2 : 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if !albums.newEmpty() {
                return albums.newCount()
            } else {
                return !albums.oldEmpty() ? albums.oldCount() : 1
            }
        } else  {
            return albums.oldCount()
        }
    }
    
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if albums.bothFilled() {
            if section == 0 {
                return "Just Made"
            } else {
                return "Albums"
            }
        }
        return nil
    }
    
   
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        print("nodeForRowAtIndexPath")
        
        func loadingCellNode() -> ASCellNodeBlock {
            return {() -> ASCellNode in
                let cellNode = HALargeLoadingCN()
                cellNode.selectionStyle = .None
                return cellNode
            }
        }
        
        func newCellNode() -> ASCellNodeBlock {

            let album = albums.newAlbumAtIndex(indexPath.row)
            
            return {() -> ASCellNode in
                let albumCellNode = MyAlbumCN(withAlbumObject: album,
                                              isSelectable: true,
                                              hasTopDivider: indexPath.row  == 0 ? false : true )
                albumCellNode.selectionStyle = .None
                albumCellNode.delegate = self
//                self.newAlbumsCellNodesList.append(albumCellNode)

                return albumCellNode
            }
        }
        
        func oldCellNode() -> ASCellNodeBlock {

            let album = albums.oldAlbumAtIndex(indexPath.row)
            return {() -> ASCellNode in
                print("1 nodeForRowAtIndexPath oldCellNode")
                let albumCellNode = MyAlbumCN(withAlbumObject: album,
                                              isSelectable   : true,
                                              hasTopDivider  : indexPath.row  == 0 ? false : true )
                albumCellNode.selectionStyle = .None
                albumCellNode.delegate = self
//                self.oldAlbumsCellNodesList.append(albumCellNode)
                print("2 nodeForRowAtIndexPath oldCellNode added old cellnode")
                print("3 nodeForRowAtIndexPath oldCellNode AlbumId: \(album.id)")

                return albumCellNode
            }
        }

        
        if albums.bothFilled() {
            
            if indexPath.section == 0 {
                
               return newCellNode()
                
            } else { // Section 1
                
                if indexPath.row < albums.oldCount() {
                    
                    return oldCellNode()
                    
                } else { // Geting more albums from server
                    
                    return loadingCellNode()
                }
            }
        } else { // Only 1 section
            if !albums.newEmpty() {
                
                return newCellNode()
                
            } else if !albums.oldEmpty() {

                if indexPath.row < albums.oldCount() {
                
                    return oldCellNode()

                } else { // Geting more albums from server
                    
                    return loadingCellNode()
                }
            } else if isLoadingAlbums {
                
                return loadingCellNode()
                
            } else {
                return {() -> ASCellNode in
                    let albumCellNode = SimpleCellNode(withMessage: "You have no albums")
                    albumCellNode.selectionStyle = .None
                    albumCellNode.userInteractionEnabled = false
                    return albumCellNode
                }
            }
        }
    }
    
    
    func printSelectedAlbums() {
        
        for album in selectedAlbumModel {
            print("Album title: \(album.title)")
        }
    }
    
    func printAlbums(list: [MyAlbumCN]) {
    
        print("==================================")
        print("==================================")
        print("==================================")
      
        for cellNode in list {
            print("CellNode \(cellNode.album.title)")
            print("CellNode \(cellNode.album.id)")
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("")
        
        print("AWWWW didSelectRowAtIndexPath: \(indexPath.section), row: \(indexPath.row)")
        let album: UserAlbumModel
        
//        let listType: [MyAlbumCN]

        if albums.bothFilled() {
            
            if indexPath.section == 0 {
                
                album = albums.newAlbumAtIndex(indexPath.row)
//                listType = newAlbumsCellNodesList

            } else { // Section 1
                
                if indexPath.row < albums.oldCount() {
                    
                    album = albums.oldAlbumAtIndex(indexPath.row)
//                    listType = oldAlbumsCellNodesList

                } else { // Geting more albums from server, This should be done automatically
                    
                    return
                }
            }
        } else { // Only 1 section
            if !albums.newEmpty() {
                
                album = albums.newAlbumAtIndex(indexPath.row)
//                listType = newAlbumsCellNodesList

            } else if !albums.oldEmpty() {
                
                if indexPath.row < albums.oldCount() {
                    
                    album = albums.oldAlbumAtIndex(indexPath.row)
//                    listType = oldAlbumsCellNodesList

                } else { // Geting more albums from server
                    
                    return
                }
            } else if isLoadingAlbums {
                
                return
                
            } else {
                
                return
            }
        }
        
        
        if let _ = album.id {
            
            
            let node = albumTableNodeDisplay.tableNode.view.nodeForRowAtIndexPath(indexPath) as! MyAlbumCN
           
            if node.album.isUploading {
                print("isUploading")
                
                Drop.down("Creating album in process",
                          state: .Warning ,
                          duration: 3.0,
                          action: nil)
            } else {
                print("not Uploading")
                node.userSelected(!node.isUserSelected)
                if node.isUserSelected {
                    addAlbumToSelectedList(node.album)
                } else {
                    removeAlbumFromSelectedList(node.album)
                }
            }
            
            if selectedAlbumModel.count > 0 {
                albumTableNodeDisplay.buttonsDisplay.enableDoneButton()
            } else {
                albumTableNodeDisplay.buttonsDisplay.disableDoneButton()
            }
        }
        printSelectedAlbums()
    }
    
    func indexOfSelectedAlbum(album: UserAlbumModel) -> Int? {
        
        return selectedAlbumModel.indexOf { (albumModel) -> Bool in
            if album === albumModel {
                return true
            }
            return false
        }
    }
    
    func addAlbumToSelectedList(album: UserAlbumModel) {
        
        let index = indexOfSelectedAlbum(album)
        
        if index == nil {
            selectedAlbumModel.append(album)
        }
    }
    
    func removeAlbumFromSelectedList(album: UserAlbumModel) {
        
        if let index = indexOfSelectedAlbum(album) {
            selectedAlbumModel.removeAtIndex(index)
        }
    }

    
    
    
    
    
    func saveNewTitle(title: String, forAlbum album: UserAlbumModel) {
        
//        let indexPath = self.albums.findAlbum(album)  //  self.albums.oldAlbumAtIndex(indexPath.row)

        
        print("saveNewTitle Is main trhread: \(NSThread.isMainThread())")
        
        
//        let cellNode = albumTableNodeDisplay.tableNode.view.nodeForRowAtIndexPath(index)
//        let cellNodes = self.findCellNodesContaining(album)
        
        //        for cellNode in cellNodes {
        //            cellNode.showSpinningWheel()
        //        }
      
        
        let indexPath = self.albums.findAlbum(album)  //  self.albums.oldAlbumAtIndex(indexPath.row)
        let cellNode  = albumTableNodeDisplay.tableNode.view.nodeForRowAtIndexPath(indexPath!) as! MyAlbumCN
        cellNode.showSpinningWheel()

        
        album.updateTitle(title) { (successful) in
            
            if successful {
                
//                let cellNodes = self.findCellNodesContaining(album)
                
//                for cellNode in cellNodes {
                    cellNode.hideSpinningWheel()
                    cellNode.replaceTitle()
//                }
                print("Saved new title")
                
            } else {
                Drop.down("Couldn't album title to \"\(title)\" \(randomUpsetEmoji())",
                          state: .Error ,
                          duration: 3.0,
                          action: nil)
            }
        }
    }
    
    
    
    // Allow to Edit users  or title
    func showOptionsForAlbum(album: UserAlbumModel) {
        
        
        print("showMoreOptions")
        let alertActionController = UIAlertController(title: "Options",
                                                message: nil,
                                                preferredStyle: .ActionSheet)
        
        // Edit Album Title
        let editTitleAction = UIAlertAction(title: "Edit Title", style: .Default) { (defaultAction) in
            print("editTitleAction pressed")
            
            
            // New Alert Controller Pop up
            let alertController = UIAlertController(title: "Change title",
                                                    message: nil,
                                                    preferredStyle: .Alert)
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { (action) in
                
                print("Saving new title")
                let newTitleTextField = alertController.textFields![0] as UITextField

                self.saveNewTitle(newTitleTextField.text!, forAlbum: album)
            })
            saveAction.enabled = false
            
            
            alertController.addTextFieldWithConfigurationHandler({ (textField) in
                textField.placeholder = "New Title"
                textField.keyboardType = .Default
                
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification,
                object: textField,
                queue: NSOperationQueue.mainQueue()) { (notification) in
                    saveAction.enabled = textField.text != ""
                }
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        alertActionController.addAction(editTitleAction)
        
        
        // Edit Friends ACL
        let editUsersAction = UIAlertAction(title: "Edit Users",
                                            style: .Default) { (defaultAction) in
                                                print("editUsersAction pressed")
                                                
            let albumIndexPath = self.albums.findAlbum(album)  //  self.albums.oldAlbumAtIndex(indexPath.row)
                                                
        }
        alertActionController.addAction(editUsersAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (canceled) in
            print("Canceled pressed")
        }
        alertActionController.addAction(cancelAction)
        presentViewController(alertActionController, animated: true, completion: nil)
    }
}


