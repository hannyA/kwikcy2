//
//  AlbumUploadVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/10/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class AlbumUploadVC: ASViewController, ASTableDelegate, ASTableDataSource,
MyAlbumCNDelegate, AlbumUploadDisplayViewDelegate, NewAlbumVCDelegate {
    
    
//    let tableNode: ASTableNode
    var profileModel: ProfileModel
    let albumTableNodeDisplay: AlbumUploadDisplayView
    
    var newPhoto: UIImage
    
    init(withPhoto photo: UIImage) {
       
        newPhoto = photo
        
        let userModel = TESTFullAppModel(numberOfUsers: 1).firstUser()
        profileModel = ProfileModel(withUser: userModel!, withNumberOfAlbums: 10)
        
        albumTableNodeDisplay = AlbumUploadDisplayView()
        
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
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
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: newAlbumVC, action: #selector(dismissVC))
        newAlbumVC.navigationItem.setLeftBarButtonItem(cancelButton, animated: false)
        
        presentViewController(newAlbumNavCon, animated: true, completion: nil)
    }
    
    
    
    func dismissVC() {
        print("AlbumUploadVC dismissVC")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    var didCreateNewAlbum = false
    var numberOfSections = 1
    
    
    
    
    
    func createNewAlbum(newAlbum: AlbumModel, usersAccessControlList: [UserModel] ) {
      
        newAlbum.insertPhotoImage(newPhoto)
        newAlbum.uploadAlbum(newAlbum)
        
        let lastRow = profileModel.insertNewAlbum(newAlbum)
       
        albumTableNodeDisplay.tableNode.view.beginUpdates()

        if !didCreateNewAlbum {
            didCreateNewAlbum = true
            let newSection      = NSIndexSet(index: 0)
            albumTableNodeDisplay.tableNode.view.insertSections(newSection, withRowAnimation: .Top)
        }
        
        let firstRowInSectionPath = NSIndexPath(forRow: 0, inSection: 0)
        let lastIndexPath   = NSIndexPath(forRow: lastRow, inSection: 1)
        
        let indexPaths = [firstRowInSectionPath, lastIndexPath]
        albumTableNodeDisplay.tableNode.view.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
       
        albumTableNodeDisplay.tableNode.view.endUpdates()
    }

    
    func cellNodesInList(list: [MyAlbumCN], forAlbum album: AlbumModel) -> [MyAlbumCN] {
        
        return list.filter({ (albumCN: MyAlbumCN) -> Bool in
            if albumCN.album.id == album.id {
                return true
            }
            return false
        })
    }
    
    
    
    
    
    
    //MARK: - ASTableDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if didCreateNewAlbum {
            return 2
        }
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if didCreateNewAlbum && section == 0 {
            return profileModel.newAlbumCount()
        }
        return profileModel.albumCount()
    }
    
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if didCreateNewAlbum && section == 0 {
            return "Just Created"
        } else if didCreateNewAlbum {
            return "Albums"
        }
        return nil
    }
    
    
  
    
    
    var selectedAlbumsCellNodesList = [AlbumModel]()
//    var albumsCellNodesNewList = [MyAlbumCN]()
    var albumsCellNodesList = [MyAlbumCN]()
    

    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        // If albums exist
        
        
        print("nodeForRowAtIndexPath")
        let album: AlbumModel
        let albumCellNode: MyAlbumCN
        
        if didCreateNewAlbum && indexPath.section == 0 {
            album = profileModel.newAlbumAtIndex(indexPath.row)
            albumCellNode = MyAlbumCN(withAlbumObject: album, atIndexPath: indexPath)
        } else {
            album = profileModel.albumAtIndex(indexPath.row)
            albumCellNode = MyAlbumCN(withAlbumObject: album, atIndexPath: indexPath)
        }
        
        albumsCellNodesList.append(albumCellNode)
        albumCellNode.selectionStyle = .None
        albumCellNode.delegate = self
        
        return albumCellNode
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let album: AlbumModel
        
        if didCreateNewAlbum && indexPath.section == 0 {
            album = profileModel.newAlbumAtIndex(indexPath.row)
        } else {
            album = profileModel.albumAtIndex(indexPath.row)
        }
        
        let albumsCellNodeList = cellNodesInList(albumsCellNodesList, forAlbum: album)
        
        print("number of album cells = \(albumsCellNodeList.count)")
        for albumsCellNode in albumsCellNodeList {
            if albumsCellNode.album.isUploading {
                print("isUploading")
                showMesage()
                break
            } else {
                print("not Uploading")
                selectedAlbumsCellNodesList.append(albumsCellNode.album)
                albumsCellNode.userSelected(!albumsCellNode.isSelected)
                
            }
        }

        
        
        
//        if didCreateNewAlbum && indexPath.section == 0 {
//            print("section 1 ============================")
//            
//            let album = profileModel.newAlbumAtIndex(indexPath.row)
//            
//            let albumsCellNodeArray = cellNodesInList(albumsCellNodesNewList, forAlbum: album)
//            
//            print("number of album cells = \(albumsCellNodeArray.count)")
//            for albumsCellNode in albumsCellNodeArray {
//                if albumsCellNode.album.isUploading {
//                    print("isUploading")
//                    // do nothing
//                    showMesage()
//                } else {
//                    print("not Uploading")
//                    // select
//                    selectedAlbumsCellNodesList.append(albumsCellNode.album)
//                    albumsCellNode.userSelected(!albumsCellNode.isSelected)
//                }
//            }
//        } else {
//            print("section 2 =============================")
//            
//            
//            let album = profileModel.albumAtIndex(indexPath.row)
//            
//            let albumsCellNodeArray = cellNodesInList(albumsCellNodesList, forAlbum: album)
//            
//            print("number of album cells = \(albumsCellNodeArray.count)")
//            for albumsCellNode in albumsCellNodeArray {
//                if albumsCellNode.album.isUploading {
//                    print("isUploading")
//                    showMesage()
//                    break
//                } else {
//                    print("not Uploading")
//                    albumsCellNode.userSelected(!albumsCellNode.isSelected)
//
//                }
//            }
//        }
    }

    
    func showMesage() {
        
    }
    
//    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
//      
//        // If albums exist
//        
//
//        if didCreateNewAlbum && indexPath.section == 0 {
//            
//            let album = profileModel.newAlbumAtIndex(indexPath.row)
//
//            return {() -> ASCellNode in
//                let albumCellNode = MyAlbumCN(withAlbumObject: album, atIndexPath: indexPath)
//                albumCellNode.userInteractionEnabled = false
//                albumCellNode.selectionStyle = .None
//                
//                albumCellNode.delegate = self
//                
//                return albumCellNode
//            }
//        } else {
//            
//        
//            
//            let album = profileModel.albumAtIndex(indexPath.row)
//
//            return {() -> ASCellNode in
//                let albumCellNode = MyAlbumCN(withAlbumObject: album, atIndexPath: indexPath)
//                albumCellNode.userInteractionEnabled = false
//                albumCellNode.selectionStyle = .None
//
//                albumCellNode.delegate = self
//                              
//                return albumCellNode
//            }
//        }
//    }
    
    
    func showMoreOptionsForObjectAtIndexPath(indexPath: NSIndexPath) {
        
        print("showMoreOptions")
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .ActionSheet)
        let editUsersAction = UIAlertAction(title: "Edit Users", style: .Default) { (defaultAction) in
            print("editUsersAction pressed")
            let album = self.profileModel.albumAtIndex(indexPath.row)
        }
        alertController.addAction(editUsersAction)
        
        let editMediaContent = UIAlertAction(title: "Edit Content", style: .Default) { (defaultAction) in
            print("editMediaContent pressed")
            let album = self.profileModel.albumAtIndex(indexPath.row)
        }
        alertController.addAction(editMediaContent)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (canceled) in
            print("Canceled pressed")
        }
        alertController.addAction(cancelAction)
        
        //        showViewController(alertController, sender: self)
        presentViewController(alertController, animated: true) {
        }
    }
    
    
   
}


