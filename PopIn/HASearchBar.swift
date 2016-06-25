//
//  HASearchBar.swift
//  PopIn
//
//  Created by Hanny Aly on 6/15/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

//
//  HATextField.swift
//  PopIn
//
//  Created by Hanny Aly on 6/15/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit



class HASearchBar: ASDisplayNode { //, UISearchBarDelegate {
    
    var searchBar: UISearchBar
    
    override init() {
        
        searchBar = UISearchBar()
        // searchBar.sizeToFit()
         searchBar.placeholder = "Search"
        searchBar.returnKeyType = .Done
        searchBar.searchBarStyle = .Prominent
        searchBar.barStyle = .Default
        
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.tintColor = UIColor.blackColor()
        super.init()
        // searchBar.delegate = self
        // searchBar.setImage(toImage, forSearchBarIcon: .Search , state: .Normal)
        
    }
    
    override func didLoad() {
        super.didLoad()
        view.addSubview(searchBar)
    }
    
    override func layout() {
        super.layout()
        searchBar.frame = view.bounds
    }
    
    /*
     ==================================================================================
     ==================================================================================
     
     SearchBar delegate
     
     ==================================================================================
     ==================================================================================
     */
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

    