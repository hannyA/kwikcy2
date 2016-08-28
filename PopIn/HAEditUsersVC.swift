//
//  HAEditUsersVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/8/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class HAEditUsersVC: ASViewController, ASTableDelegate, ASTableDataSource, UITextFieldDelegate, UISearchBarDelegate {
    

    
    var tableNode: ASTableNode
    var friendsModel = FriendsModel()
    
    
    typealias IndexRow = Int
    
    init() {
        print("NewAlbumVC init")
        
        tableNode = ASTableNode(style: .Plain)
        
        super.init(node: tableNode)
        
        tableNode.dataSource = self
        tableNode.delegate = self
        
        navigationItem.title = "Friends"
        
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .Plain,
                                           target: self,
                                           action: #selector(dismissVC))
        
        navigationItem.setLeftBarButtonItem(cancelButton, animated: false)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(
                NSURL(fileURLWithPath: NSTemporaryDirectory())
                    .URLByAppendingPathComponent("download"),
                //                    .URLByAppendingPathComponent(UserUploadFriendModel.ProfileImageType.Crop.rawValue),
                withIntermediateDirectories: true,
                attributes: nil)
            
        } catch {
            print("Creating 'download' directory failed. Error: \(error)")
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        friendsModel.load({ (success) in
            
            print("friendsModel.load")
            
            if success {
                
            } else {
                
            }
            
            self.tableNode.view.reloadData()
        })
    }
    
//    
//    func reloadFriends() {
//        tableNode.view.reloadSections(NSIndexSet(index: 1),
//                                      withRowAnimation: .None)
//    }
    
    
    func dismissVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    //MARK: - ASTableDataSource methods
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if friendsModel.isLoading {
            return friendsModel.userCount() + 1
        } else {
            return friendsModel.userCount() > 0 ? friendsModel.userCount() : 1
        }
    }
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        if friendsModel.isLoading && indexPath.row == friendsModel.userCount() {
            return {() -> ASCellNode in
                let cellNode = HALargeLoadingCN()
                cellNode.selectionStyle = .None
                return cellNode
            }
        } else if friendsModel.userCount() == 0 {
            
            return {() -> ASCellNode in
                let albumCellNode = SimpleCellNode(withMessage: "No friends found")
                albumCellNode.selectionStyle = .None
                albumCellNode.userInteractionEnabled = false
                return albumCellNode
            }
        }
        // else friends row
        
        let friendModel = friendsModel.userAtIndex(indexPath.row)
        
        var shouldHaveDivider = true
        if indexPath.row == 0 {
            shouldHaveDivider = false
        }
        
        let cellNode = {() -> ASCellNode in
            
            let friendCN = HASearchFriendCN(withUserModel: friendModel,
                                            hasDivider: shouldHaveDivider)
            friendCN.selectionStyle = .None
            
            return friendCN
        }
        return cellNode
    }
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//
//        //
//        if indexPath.section == 1 {
//            
//            if friendsModel.isLoading && indexPath.row == friendsModel.userCount() {
//                
//                return
//            }
//            
//            let userModel = friendsModel.userAtIndex(indexPath.row)
//            
//            //            let userModel = testAppModel.searchResultAtIndex(indexPath.row)
//            
//            // print("userModelname \(userModel.userName)")
//            
//            let cellNodeIndex = showingFriendsCells.indexOf({ (friendCN: HASearchFriendCN) -> Bool in
//                
//                // print("showingFriendsCells.username = \(friendCN.userModel.userName)")
//                if friendCN.userModel.userName == userModel.userName {
//                    return true
//                }
//                return false
//            })
//            
//            // print("cellNodeIndex: \(cellNodeIndex)")
//            // print("showingFriendsCells: \(showingFriendsCells.count)")
//            
//            let cellNode = showingFriendsCells[cellNodeIndex!]
//            cellNode.userSelected(!cellNode.isUserSelected)
//            
//            if !cellNode.isUserSelected {
//                let selectedIndex = selectedFriendsModel.indexOf({ (selectedUser: UserUploadFriendModel) -> Bool in
//                    if userModel.userName == selectedUser.userName {
//                        return true
//                    }
//                    return false
//                })
//                
//                selectedFriendsModel.removeAtIndex(selectedIndex!)
//                horizontalCollectionUsersCN!.deleteItemAtIndexPathRow(selectedIndex!)
//                
//                if selectedFriendsModel.count == 0 {
//                    newAlbumDisplayView.tableNode.view.deleteRowsAtIndexPaths([NSIndexPath(forRow:1, inSection:0)],
//                                                                              withRowAnimation: .Top)
//                }
//            } else  {
//                
//                selectedFriendsModel.append(userModel)
//                
//                // Show the collection View
//                if selectedFriendsModel.count == 1 {
//                    
//                    print("selectedFriendsModel count = 1")
//                    beginTableUpdates()
//                    
//                    insertRowsAtIndexPaths([NSIndexPath(forRow: 1,inSection:0)], animation: .Top)
//                    
//                    newAlbumDisplayView.tableNode.view.endUpdates()
//                    
//                } else {
//                    print("selectedFriendsModel count != 1")
//                    horizontalCollectionUsersCN!.insertItemAtIndexPathRow(selectedFriendsModel.endIndex-1)
//                }
//            }
//            enableBottomButton()
//        }
    }
    
    
    func insertRowsAtIndexPaths(indexPaths: [NSIndexPath], animation: UITableViewRowAnimation ) {
        tableNode.view.insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
    }
    
    
    func beginTableUpdates() {
        tableNode.view.beginUpdates()
    }
    
    
    func endTableUpdates() {
        tableNode.view.endUpdates()
    }
    
    
    
//    
//    func enableBottomButton() {
//        if selectedFriendsModel.count > 0 && albumTitle.characters.count > 0  {
//            newAlbumDisplayView.enableBottomButton(true)
//        } else {
//            newAlbumDisplayView.enableBottomButton(false)
//        }
//    }
    
    
    
    
    
    
    
    
//    
//    
//    
//    var searchBar: UISearchBar?
//    var textField: UITextField?
//    /*
//     ==================================================================================
//     ==================================================================================
//     
//     SearchBar delegate
//     
//     ==================================================================================
//     ==================================================================================
//     */
//    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        self.searchBar = searchBar
//        searchBar.setShowsCancelButton(true, animated: true)
//    }
//    
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        dismissSearchBar(searchBar)
//    }
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        print("textDidChange to: \"\(searchText)\"")
//        
//        
//        beginTableUpdates()
//        
//        if let filterResults = friendsModel.fetchDeletedSearchResults(searchText) {
//            tableNode.view.deleteRowsAtIndexPaths(filterResults, withRowAnimation: .Top)
//        }
//        if let filterResults = friendsModel.fetchInsertSearchResults(searchText) {
//            tableNode.view.insertRowsAtIndexPaths(filterResults, withRowAnimation: .Top)
//        }
//        endTableUpdates()
//    }
//    
//    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        dismissSearchBar(searchBar)
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    /*
//     ==================================================================================
//     ==================================================================================
//     
//     TextField delegate
//     
//     ==================================================================================
//     ==================================================================================
//     */
//    
//    
//    
//    
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        self.textField = textField
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    
//    
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//        print("textFieldDidEndEditing: \(textField.text)")
//        
////        albumTitle = textField.text!
//        
//        enableBottomButton()
//    }
//    
//    
//    func textFieldShouldClear(textField: UITextField) -> Bool {
//        
////        albumTitle = ""
//        return true
//    }
//    
//    
//    
//    
//    
//    
//    /*
//     ==================================================================================
//     ==================================================================================
//     
//     TextField and SearchBar Helper Methods
//     
//     ==================================================================================
//     ==================================================================================
//     */
//    
//    
//    func dismissSearchBar(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchBar.setShowsCancelButton(false, animated: true)
//    }
//    
//    
//    func hideKeyBoard() {
//        if let textField = textField {
//            textField.resignFirstResponder()
//        }
//        if let searchBar = searchBar {
//            searchBar.resignFirstResponder()
//            searchBar.setShowsCancelButton(false, animated: true)
//        }
//    }
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        hideKeyBoard()
//    }
    
}


