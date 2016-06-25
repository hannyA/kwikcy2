//
//  HASearchControllerNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/20/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit



class HASearchControllerNode: ASDisplayNode { //, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override init() {
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search..."

        searchController.searchBar.tintColor = UIColor.blackColor()
        searchController.searchBar.barTintColor = UIColor.whiteColor()
        searchController.searchBar.backgroundColor = UIColor.greenColor()

        
        searchController.searchBar.searchBarStyle = .Prominent
        searchController.searchBar.barStyle = .Default

        super.init()
        
        
    }
    
    override func didLoad() {
        super.didLoad()
        view.addSubview(searchController.searchBar)
    }
    
    override func layout() {
        super.layout()
        searchController.searchBar.frame = view.bounds
   }
    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {}
}

    