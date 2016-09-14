//
//  NewAlbumVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


protocol NewAlbumVCDelegate {
    func dismissVC()
    func createNewAlbum(album: UserAlbumModel )

}

class NewAlbumVC: ASViewController, ASTableDelegate, ASTableDataSource, UITextFieldDelegate, HorizontalScrollCellDelegate, UISearchBarDelegate {
    
    var delegate: NewAlbumVCDelegate?
    let newAlbumDisplayView: NewAlbumDisplayView
    var horizontalCollectionUsersCN: HorizontalScrollCell?
    
    var friendsModel = FriendsModel()
    var albumTitle: String = ""
    
    
    let rowsCountInTopSection = 1 // When we include search functionality, change this to 3

    typealias IndexRow = Int
    
    init() {
        print("NewAlbumVC init")

        newAlbumDisplayView = NewAlbumDisplayView()
        
        super.init(node: newAlbumDisplayView)

        newAlbumDisplayView.tableNode.dataSource = self
        newAlbumDisplayView.tableNode.delegate = self
      
        navigationItem.title = "New Album"
        
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
        newAlbumDisplayView.tableNode.view.allowsSelection = true
        newAlbumDisplayView.tableNode.view.separatorStyle = .None
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
       
        newAlbumDisplayView.buttonDisplay.button.addTarget(self,
                                                           action: #selector(createNewAlbum),
                                                           forControlEvents: .TouchUpInside)
        
        
        friendsModel.load({ (success) in
            
            print("friendsModel.load")
            
            if success {
                
            } else {
                
            }
            
            self.reloadFriends()
        })
    }
    
    
    func reloadFriends() {
        newAlbumDisplayView.tableNode.view.reloadSections(NSIndexSet(index: 1),
                                                          withRowAnimation: .None)
    }
    
    
    
    // Send async request to server to create album, dimiss VC, add row to tableview, but unselectable, 
    // show spinning wheel over album image, and gray out the whole row
    // pass along a completion block
    
//    AWSLambdaCreateAlbum
    
    func createNewAlbum() {
       
        var friendsGuidList = [String]()
        
        for selectedUser in selectedFriendsModel {
            friendsGuidList.append(selectedUser.guid)
        }
        
        let newAlbum = UserAlbumModel(withTitle: albumTitle, usersAccessControlList: friendsGuidList)

        delegate?.createNewAlbum(newAlbum)
        dismissVC()
    }
    
    
    func dismissVC() {
        delegate?.dismissVC()
    }
    

    
    
    //MARK: - ASTableDataSource methods
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if selectedFriendsModel.count > 0 {
                return rowsCountInTopSection + 1 // Add 1 for Hozizontal Collection Cell node to store user photos
            } else {
                return rowsCountInTopSection
            }
        } else if friendsModel.isLoading {
            return friendsModel.userCount() + 1
        } else {
            return friendsModel.userCount() > 0 ? friendsModel.userCount() : 1
        }
    }
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                return {() -> ASCellNode in
                    let titleCN = HATitleCN()
                    titleCN.selectionStyle = .None
                    titleCN.textFieldNode.textField.delegate = self
                    return titleCN
                }
            } else { // if selectedFriendsModel.count > 0 {
                return {() -> ASCellNode in
                    
                    let elementSize:CGFloat = 50
                    
                    self.horizontalCollectionUsersCN = HorizontalScrollCell(initWithElementSize: CGSizeMake(elementSize, elementSize))
                    self.horizontalCollectionUsersCN!.selectionStyle = .None
                    
                    self.horizontalCollectionUsersCN!.delegate = self
                    
                    return self.horizontalCollectionUsersCN!
                }
            }
//            else {
//                return {() -> ASCellNode in
//                    let searchTextVC = HASearchCN()
//                    searchTextVC.selectionStyle = .None
//                    searchTextVC.searchBarNode.searchBar.delegate = self
//                    return searchTextVC
//                }
//            }
        } else { // section 1
            
            if friendsModel.isLoading && indexPath.row == friendsModel.userCount() {
                return {() -> ASCellNode in
                    let cellNode = HALargeLoadingCN()
                    cellNode.selectionStyle = .None
                    return cellNode
                }
            } else if friendsModel.userCount() == 0 {
                
                return {() -> ASCellNode in
                    let albumCellNode = SimpleCellNode(withMessage: "Find friends before you make an album")
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
            
//            let friendCN = HASearchFriendCN(withUserModel: friendModel, hasDivider: shouldHaveDivider)
//            self.showingFriendsCells.append(friendCN)

            let cellNode = {() -> ASCellNode in
                let friendCN = HASearchFriendCN(withUserModel: friendModel, hasDivider: shouldHaveDivider)
                self.showingFriendsCells.append(friendCN)

                if self.selectedFriendsModel.contains(friendModel) {
                    friendCN.userSelected(true)
                } else {
                    friendCN.userSelected(false)
                }
                
                friendCN.selectionStyle = .None

                return friendCN
            }
            return cellNode
        }
    }
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Get user from list, add to array and show in the second textfield (does not exist yet)
        
        hideKeyBoard()
        
        if indexPath.section == 1 {
            
            if friendsModel.isLoading && indexPath.row == friendsModel.userCount() {

                return
            }
            
            let userModel = friendsModel.userAtIndex(indexPath.row)
            
//            let userModel = testAppModel.searchResultAtIndex(indexPath.row)
            
            // print("userModelname \(userModel.userName)")
          
            let cellNodeIndex = showingFriendsCells.indexOf({ (friendCN: HASearchFriendCN) -> Bool in
              
                // print("showingFriendsCells.username = \(friendCN.userModel.userName)")
                if friendCN.userModel.userName == userModel.userName {
                    return true
                }
                return false
            })

            // print("cellNodeIndex: \(cellNodeIndex)")
            // print("showingFriendsCells: \(showingFriendsCells.count)")
            
            let cellNode = showingFriendsCells[cellNodeIndex!]
            cellNode.userSelected(!cellNode.isUserSelected)
            
            if !cellNode.isUserSelected {
                let selectedIndex = selectedFriendsModel.indexOf({ (selectedUser: UserUploadFriendModel) -> Bool in
                    if userModel.userName == selectedUser.userName {
                        return true
                    }
                    return false
                })
                
                selectedFriendsModel.removeAtIndex(selectedIndex!)
                horizontalCollectionUsersCN!.deleteItemAtIndexPathRow(selectedIndex!)
                
                if selectedFriendsModel.count == 0 {
                    newAlbumDisplayView.tableNode.view.deleteRowsAtIndexPaths([NSIndexPath(forRow:1, inSection:0)],
                                                                              withRowAnimation: .Top)
                }
            } else  {

                selectedFriendsModel.append(userModel)
                
                // Show the collection View
                if selectedFriendsModel.count == 1 {

                    print("selectedFriendsModel count = 1")
                    beginTableUpdates()
                   
                    insertRowsAtIndexPaths([NSIndexPath(forRow: 1,inSection:0)], animation: .Top)
                    
                    newAlbumDisplayView.tableNode.view.endUpdates()
                
                } else {
                    print("selectedFriendsModel count != 1")
                    horizontalCollectionUsersCN!.insertItemAtIndexPathRow(selectedFriendsModel.endIndex-1)
                }
            }
            enableBottomButton()
        }
    }
    
    
    func insertRowsAtIndexPaths(indexPaths: [NSIndexPath], animation: UITableViewRowAnimation ) {
        newAlbumDisplayView.tableNode.view.insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
    }
    
    
    func beginTableUpdates() {
        newAlbumDisplayView.tableNode.view.beginUpdates()
    }
    
    
    func endTableUpdates() {
        newAlbumDisplayView.tableNode.view.endUpdates()
    }
    
    
    
    
    func enableBottomButton() {
        if selectedFriendsModel.count > 0 && albumTitle.characters.count > 0  {
            newAlbumDisplayView.enableBottomButton(true)
        } else {
            newAlbumDisplayView.enableBottomButton(false)
        }
    }
    
    
    func numberOfItemsInCollectionView() -> Int {
        print("selectedFriendsModel.count: \(selectedFriendsModel.count)")
        return selectedFriendsModel.count
    }
    
    
    
    func itemAtIndexPathRow(index: Int) -> UserUploadFriendModel {
        let userModel = selectedFriendsModel[index]
        
        return userModel
    }
    
    
    
    
    var showingFriendsCells = [HASearchFriendCN]()  // not sorted
    var selectedFriendsModel = [UserUploadFriendModel]() // change to userIds/usernames not sorted

    
    
//    var showingFriends = [IndexRow: HASearchFriendCN]()
//    //    var selectedFriendsDict = [IndexRow: UserUploadFriendModel]()
//    var selectedFriends = [IndexRow]()
    
    
    
    
    
    
    func deleteItemFromTableAndCollectionNodeAtSelectedFriendsIndexRow(selectedFriendsIndexPathRow: Int) {

        let userModel = selectedFriendsModel.removeAtIndex(selectedFriendsIndexPathRow)
        
        let cellNodeIndex = showingFriendsCells.indexOf { (friendsCN: HASearchFriendCN) -> Bool in
            
            if friendsCN.userModel.userName == userModel.userName {
                return true
            }
            return false
        }
        let cellNode = showingFriendsCells[cellNodeIndex!]
        cellNode.userSelected(false)
        
        horizontalCollectionUsersCN!.deleteItemAtIndexPathRow(selectedFriendsIndexPathRow)
        if selectedFriendsModel.count == 0 {
            newAlbumDisplayView.tableNode.view.deleteRowsAtIndexPaths([NSIndexPath(forRow:1, inSection:0)],
                                                                      withRowAnimation: .Bottom)
        }
    }
    
    
    
    
    
    var searchBar: UISearchBar?
    var textField: UITextField?
    /*
     ==================================================================================
     ==================================================================================
     
     SearchBar delegate
     
     ==================================================================================
     ==================================================================================
     */
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar = searchBar
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        dismissSearchBar(searchBar)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange to: \"\(searchText)\"")
        
    
        beginTableUpdates()
        
        if let filterResults = friendsModel.fetchDeletedSearchResults(searchText) {
            newAlbumDisplayView.tableNode.view.deleteRowsAtIndexPaths(filterResults, withRowAnimation: .Top)
        }
        if let filterResults = friendsModel.fetchInsertSearchResults(searchText) {
            newAlbumDisplayView.tableNode.view.insertRowsAtIndexPaths(filterResults, withRowAnimation: .Top)
        }
        endTableUpdates()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        dismissSearchBar(searchBar)
    }
    
    
    
    
    
    
    
    
    /*
     ==================================================================================
     ==================================================================================
     
                        TextField delegate
     
     ==================================================================================
     ==================================================================================
     */
    
    

    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.textField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("textFieldDidEndEditing: \(textField.text)")
        
        albumTitle = textField.text!

        enableBottomButton()
    }
    
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        
        albumTitle = ""
        return true
    }
    
    
    
    
    
    
    /*
     ==================================================================================
     ==================================================================================
     
                    TextField and SearchBar Helper Methods
     
     ==================================================================================
     ==================================================================================
     */

    
    func dismissSearchBar(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    
    func hideKeyBoard() {
        if let textField = textField {
            textField.resignFirstResponder()
        }
        if let searchBar = searchBar {
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        hideKeyBoard()
    }
    
}


