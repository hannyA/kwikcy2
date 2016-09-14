//
//  HASearchVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/19/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AWSS3
import AWSMobileHubHelper
import AsyncDisplayKit

class HASearchTableVC: ASViewController, ASTableDelegate, ASTableDataSource, UISearchBarDelegate {
    
    let tableNode: ASTableNode
    var searchBar: UISearchBar
    var searchResults = SearchModel()

    let tapBackground: UITapGestureRecognizer
    
    var didNotSearch = true

    var fetchingSearchResults = false
    var serverError = false
   
    let downloadManager = HADownloadManager(imageType: .Crop)

    
    init() {
        searchBar = UISearchBar()
        
        searchBar.autocapitalizationType = .None
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Users"
        searchBar.searchBarStyle = .Minimal
        searchBar.barStyle = .Default
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.tintColor = UIColor.blackColor()
        
        
        // userModelFirstThreeLettersSearchResults = [UserModel]()
        
        tableNode = ASTableNode(style: .Plain)
        
        tapBackground = UITapGestureRecognizer()
        
        super.init(node: tableNode)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapBackground.addTarget(self, action: #selector(hideKeyboard))
        tapBackground.numberOfTapsRequired = 1
        tapBackground.cancelsTouchesInView = false
        
        tableNode.delegate = self
        tableNode.dataSource = self
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
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
    
    
    
    //MARK: - ASTableDataSource methods
    
    //TODO: when we get more sophisticated
    //  we'll add multiple section where we have top hits.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if didNotSearch {
            return 0
        }
        else if fetchingSearchResults || searchResults.isEmpty() || serverError {
            return 1
        } else {
            return searchResults.count()
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        hideKeyboard()
        
        tableNode.view.deselectRowAtIndexPath(indexPath, animated: true)

        
        let userModel = searchResults.indexOf( indexPath.row)
        
        let userProfileVC = UserProfilePageVC(withUserSearchModel: userModel)
        userProfileVC.navigationItem.title = userModel.userName.uppercaseString
      
        print("\(userModel.userName.uppercaseString)")

        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        if serverError {
            
            let noUserFoundCN =  {() -> ASCellNode in
                let cellNode = SimpleCellNode(withMessage: AWSErrorBackend)
                return cellNode
            }
            return noUserFoundCN
            
        }
        else if fetchingSearchResults {
            let searchingCN =  {() -> ASCellNode in
                let cellNode = SimpleCellNode(withMessage: "Searching for \"\(self.searchText)\"")
                return cellNode
            }
            return searchingCN
            

        } else if searchResults.isEmpty() {
            
            let noUserFoundCN =  {() -> ASCellNode in
                let cellNode = SimpleCellNode(withMessage: "No User Found")
                return cellNode
            }
            return noUserFoundCN
            
        } else {
            
            let searchResult = searchResults.indexOf(indexPath.row)
            
            
            let cellNode =  {() -> ASCellNode in
                let searchCN = UserSearchTableCN(withUserResult: searchResult)
                return searchCN
            }
            return cellNode
        }
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
    

    

    var searchText: String = ""
    
    
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
    
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar:textDidChange for text: \(searchText)")
    
        self.searchText = searchText
        
        downloadManager.cancelAllDownloads()
        searchResults.removeAllResults()
        
        tableNode.view.reloadData()

        
        if searchText.characters.isEmpty {
            didNotSearch = true
            return
        }
        
        // Clear everything
        fetchingSearchResults = true
        serverError = false
        didNotSearch = false
        
        
        let jsonInput = ["searchText": searchText]
        
//        var parameters: [String: AnyObject]
//        
//        do {
//            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonInput, options: .PrettyPrinted)
//            let anyObj = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [String: AnyObject]
//            parameters = anyObj
//            
//        } catch let error as NSError {
//            print("json error: \(error.localizedDescription)")
//            return
//        }
//        
        searchResults.query(jsonInput) { (serverError, errorMessage) in
            
            self.fetchingSearchResults = false
            self.serverError = serverError
            
            self.tableNode.view.reloadData()
            
            self.downloadManager.setDownloadProfileImages(self.searchResults.results())
            
            self.downloadManager.downloadAllUserThumbImages()
        }
        
        
        
//        beginTableUpdates()
//        
//
//        if let filterResults = testModelData.fetchDeletedSearchResults(searchText) {
//            
//            
//            tableNode.view.deleteRowsAtIndexPaths(filterResults, withRowAnimation: .Top)
//        }
//        if let filterResults = testModelData.fetchInsertSearchResults(searchText) {
//            
//            tableNode.view.insertRowsAtIndexPaths(filterResults, withRowAnimation: .Top)
//        }
//        endTableUpdates()

        
        
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
}


