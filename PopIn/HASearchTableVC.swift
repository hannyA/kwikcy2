//
//  HASearchVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/19/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



import UIKit
import AsyncDisplayKit

class HASearchTableVC: ASViewController, ASTableDelegate, ASTableDataSource, UISearchBarDelegate {
    
    let tableNode: ASTableNode
    var searchBar: UISearchBar
    
    let testModelData:TESTFullAppModel
//    var userModelFirstThreeLettersSearchResults: [UserModel]

    let tapBackground: UITapGestureRecognizer

    
    init() {
        testModelData = TESTFullAppModel(indexPathSection: 0)
        testModelData.resetSearchResults()
        
        searchBar = UISearchBar()
        
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Users"
        searchBar.searchBarStyle = .Minimal
        searchBar.barStyle = .Default
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.tintColor = UIColor.blackColor()
        
        
//            UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self];
//            // Use the current view controller to update the search results.
//            searchController.searchResultsUpdater = self;
//            // Install the search bar as the table header.
//            self.navigationItem.titleView = searchController.searchBar;
//            // It is usually good to set the presentation context.
//            self.definesPresentationContext = YES;
//            
//            
//            
//            UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
//            
////            self.searchBar = searchbar
//            return self.searchBar
//        })
        

        
        
        //            UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self];
        //            // Use the current view controller to update the search results.
        //            searchController.searchResultsUpdater = self;
        //            // Install the search bar as the table header.
        //            self.navigationItem.titleView = searchController.searchBar;
        //            // It is usually good to set the presentation context.
        //            self.definesPresentationContext = YES;
        
        
//        userModelFirstThreeLettersSearchResults = [UserModel]()
        
        tableNode = ASTableNode(style: .Plain)
        
        tapBackground = UITapGestureRecognizer()
        
        super.init(node: tableNode)
        
        
        tapBackground.addTarget(self, action: #selector(hideKeyboard))
        tapBackground.numberOfTapsRequired = 1
        tapBackground.cancelsTouchesInView = false

        tableNode.delegate = self
        tableNode.dataSource = self
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        addBackgroundTouch()
        searchBar.becomeFirstResponder()
    }
    
    
    
    func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    func showKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    func addBackgroundTouch() {
        tableNode.view.addGestureRecognizer(tapBackground)
    }
    
    func removeBackgroundTouch() {
        tableNode.view.removeGestureRecognizer(tapBackground)
    }
    
    
    
    
    
    func showProfileForUser(userModel: UserModel) {
        
    }
    
    
    //MARK: - ASTableDataSource methods
    
    //TODO: when we get more sophisticated
    //  we'll add multiple section where we have top hits.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if testModelData.searchResultsCount() > 0 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testModelData.searchResultsCount()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        hideKeyboard()
        
        print("didSelectRowAtIndexPath")
        
        tableNode.view.deselectRowAtIndexPath(indexPath, animated: true)

        let userModel = testModelData.searchResultAtIndex(indexPath.row)
        
        let userProfileVC = UserProfilePageVC(withUserModel: userModel)
        userProfileVC.navigationItem.title = userModel.userName?.uppercaseString
      
        print("\(userModel.userName?.uppercaseString)")

        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        let userModel = testModelData.searchResultAtIndex(indexPath.row)
        
        let a =  {() -> ASCellNode in
            let userCellNode = UserSearchTableCN(withUserModel: userModel)
            return userCellNode
        }
        return a
        
    
        
        /*
 
 hash range
         
         For letter A: 1) Get username "a", and get 20 other usernames with username starting with "a"
         Let Database Table store only 20 us
         
         
         
         Table 1: Hash     Range (username)                     # Followers
                    0
                    1
                    2
                    3
                    ...
                    9
                    a       a, aa, aaa, aba, adam, ariel22,     a (1,000), aa (23,000)
                    b
                    c
                    d
                    .
                    .
                    .
                    z
        
         
         Global Secondary Index Table
         
         Hash(# followers) Range (username)
         23,000

         
 */
        
        
//        let album: AlbumModel
//        
//        if feedModel.hasNewAlbums() {
//            if indexPath.section == NewAlbumSection {
//                album = feedModel.newAlbumIdAtIndex(indexPath.row)
//            } else {
//                album = feedModel.albumAtIndex(indexPath.row)!
//            }
//            //Only seen albums
//        } else {//feedModel.totalNumberOfAlbums() > 0 {
//            album = feedModel.albumAtIndex(indexPath.row)!
//        }
//        
//        // this may be executed on a background thread - it is important to make sure it is thread safe
//        return {() -> ASCellNode in
//            return AlbumCellNode(withAlbumObject: album)
//        }
//        //        return albumCellNodeBlock
    }
    
    
    
    
    
    
    
    /*
     ==================================================================================
     ==================================================================================
     
     SearchBar delegate
     
     ==================================================================================
     ==================================================================================
     */
    
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideKeyboard()
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
    



    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar:textDidChange for text: \(searchText)")
        
        
        beginTableUpdates()
        
        
        if let filterResults = testModelData.fetchDeletedSearchResults(searchText) {
            
            
            tableNode.view.deleteRowsAtIndexPaths(filterResults, withRowAnimation: .Top)
        }
        if let filterResults = testModelData.fetchInsertSearchResults(searchText) {
            
            tableNode.view.insertRowsAtIndexPaths(filterResults, withRowAnimation: .Top)
        }
        endTableUpdates()

        
        
//        if searchText.characters.count > 2 {
//            let modelData = testModelData.searchUsersWithPrefix(searchText)
//            print("Modedata count \(modelData.count)")
//            userModelSearchResults.removeAll()
//            userModelSearchResults.appendContentsOf(modelData)
//            
//            tableNode.view.reloadData()
//        } else {
//            userModelSearchResults.removeAll()
//            tableNode.view.reloadData()
//        }
        
        
    }
    
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        print("searchBarShouldEndEditing")
        return true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")

    }
    
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
    }
    
    
    
}