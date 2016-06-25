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
    func createNewAlbum( newAlbum: AlbumModel, usersAccessControlList: [UserModel] )

}

class NewAlbumVC: ASViewController, ASTableDelegate, ASTableDataSource, UITextFieldDelegate, HorizontalScrollCellDelegate, UISearchBarDelegate {
    
    var delegate: NewAlbumVCDelegate?
    let testAppModel: TESTFullAppModel
    let newAlbumDisplayView: NewAlbumDisplayView
    var horizontalCollectionUsersCN: HorizontalScrollCell?
    
    
    var albumTitle: String = ""
    

//    var collectionAppearedOnce = false
    
    typealias IndexRow = Int
    
    init() {
    
        print("NewAlbumVC init")
        testAppModel = TESTFullAppModel(indexPathSection: 1)
        testAppModel.resetSearchResults()
        newAlbumDisplayView = NewAlbumDisplayView()
        
        super.init(node: newAlbumDisplayView)

        newAlbumDisplayView.tableNode.dataSource = self
        newAlbumDisplayView.tableNode.delegate = self
      
        title = "New Album"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        newAlbumDisplayView.tableNode.view.allowsSelection = true
        newAlbumDisplayView.tableNode.view.separatorStyle = .None
        
        newAlbumDisplayView.buttonDisplay.button.addTarget(self,
                                                           action: #selector(createNewAlbum),
                                                           forControlEvents: .TouchUpInside)
    }
    
    
    
    
    // Send async request to server to create album, dimiss VC, add row to tableview, but unselectable, 
    // show spinning wheel over album image, and gray out the whole row
    // pass along a completion block
    
    
    func createNewAlbum() {
       
        var friendList = [UserModel]()
        
        for i in 0..<selectedFriendsModel.count {
            let user = selectedFriendsModel[i]
            friendList.append(user)
        }
        
        let newAlbum = AlbumModel(withTitle: albumTitle)
        
        delegate?.createNewAlbum(newAlbum, usersAccessControlList: friendList)
        
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
                return 3
            } else {
                return 2
            }
        } else {
            return testAppModel.searchResultsCount()
        }
    }
        
    
    
//    
//    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
//        
//        let section = indexPath.section
//        let row = indexPath.row
//        
//        if section == 0 {
//            
//            if row == 0 {
//                let titleCN = HATitleCN()
//                titleCN.selectionStyle = .None
//                titleCN.textFieldNode.textField.delegate = self
//                return titleCN
//            } else if selectedFriendsModel.count > 0 {
//                return horizontalCollectionUsersCN
//            } else {
//                let searchTextVC = HASearchCN()
//                searchTextVC.selectionStyle = .None
//                searchTextVC.searchBarNode.searchBar.delegate = self
//                return searchTextVC
//            }
//        } else {
//            
//        let friendModel = testAppModel.searchResultAtIndex(row) // .userAtIndex(modelRow)
//        
////        print("friendModel.userName \(friendModel.userName)")
//        
//            var shouldHaveDivider = true
//            if row == 0 {
//                shouldHaveDivider = false
//            }
//            let friendCN = HASearchFriendCN(withUserModel: friendModel, hasDivider: shouldHaveDivider)
//            
////            print("friendCN username \(friendCN.userModel.userName)")
//            
//            if self.selectedFriendsModel.contains(friendModel) {
//                friendCN.userSelected(true)
//            } else {
//                friendCN.userSelected(false)
//            }
//            friendCN.selectionStyle = .None
//            showingFriendsCells.append(friendCN)
//            return friendCN
//        }
//    }
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            
            if row == 0 {
                return {() -> ASCellNode in
                    let titleCN = HATitleCN()
                    titleCN.selectionStyle = .None
                    titleCN.textFieldNode.textField.delegate = self
                    return titleCN
                }
            } else if selectedFriendsModel.count > 0 {
                return {() -> ASCellNode in
                    
                    let elementSize:CGFloat = 50
                    
                    self.horizontalCollectionUsersCN = HorizontalScrollCell(initWithElementSize: CGSizeMake(elementSize, elementSize))
                    self.horizontalCollectionUsersCN!.selectionStyle = .None
                    
                    self.horizontalCollectionUsersCN!.delegate = self
                    
                    return self.horizontalCollectionUsersCN!
                }
            } else {
                return {() -> ASCellNode in
                    let searchTextVC = HASearchCN()
                    searchTextVC.selectionStyle = .None
                    searchTextVC.searchBarNode.searchBar.delegate = self
                    return searchTextVC
                }
            }
        } else {

            print("nodeBlockForRowAtIndexPath friendModel =================================")

            let friendModel = testAppModel.searchResultAtIndex(row) // .userAtIndex(modelRow)
            print("nodeBlockForRowAtIndexPath friendModel =================================")

            var shouldHaveDivider = true
            if row == 0 {
                shouldHaveDivider = false
            }
            
            let friendCN = HASearchFriendCN(withUserModel: friendModel, hasDivider: shouldHaveDivider)
            self.showingFriendsCells.append(friendCN)

            print("friendModel.userName ============================================= \(friendModel.userName)")
            let cellNode = {() -> ASCellNode in
                
//                let friendCN = HASearchFriendCN(withUserModel: friendModel, hasDivider: shouldHaveDivider)
                
                print("friendCN username ===================================\(friendCN.userModel.userName)")

                if self.selectedFriendsModel.contains(friendModel) {
                    friendCN.userSelected(true)
                } else {
                    friendCN.userSelected(false)
                }
                
                print("friendCN username  ====================================\(friendCN.userModel.userName) End 2")

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
            
            let userModel = testAppModel.searchResultAtIndex(indexPath.row)
            
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
            cellNode.userSelected(!cellNode.isSelected)
            
            if !cellNode.isSelected {
                let selectedIndex = selectedFriendsModel.indexOf({ (selectedUser: UserModel) -> Bool in
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
                    
//                    collectionAppearedOnce = true
//                    if !collectionAppearedOnce {
//                        newAlbumDisplayView.tableNode.view.endUpdates()
//                        collectionAppearedOnce = true
//                    } else  {
//                        
//                        newAlbumDisplayView.tableNode.view.endUpdatesAnimated(true, completion: { (completed) in
//                            print("selectedFriendsModel count once")
//                            self.horizontalCollectionUsersCN!.insertItemAtIndexPathRow(self.selectedFriendsModel.endIndex-1)
//                        })
//                    }
                
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
    
    
    
    func itemAtIndexPathRow(index: Int) -> UserModel {
        print("itemAtIndexPathRow")
        let userModel = selectedFriendsModel[index]
        print("itemAtIndexPathRow row \(index)")
        
        return userModel
    }
    
    
    
    
    var showingFriendsCells = [HASearchFriendCN]()  // not sorted
    var selectedFriendsModel = [UserModel]() // change to userIds/usernames not sorted

    
    
//    var showingFriends = [IndexRow: HASearchFriendCN]()
//    //    var selectedFriendsDict = [IndexRow: UserModel]()
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
        
        if let filterResults = testAppModel.fetchDeletedSearchResults(searchText) {
            newAlbumDisplayView.tableNode.view.deleteRowsAtIndexPaths(filterResults, withRowAnimation: .Top)
        }
        if let filterResults = testAppModel.fetchInsertSearchResults(searchText) {
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


