//
//  HASearchCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit



class HASearchCN: ASCellNode {
//, UISearchBarDelegate {
    
    let searchBarNode: HASearchBar

    override init() {
        searchBarNode = HASearchBar()
        super.init()
        
//        searchBarNode.searchBar.delegate = self
//        backgroundColor = UIColor.greenColor()
        addSubnode(searchBarNode)
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let preferredSize =  CGSizeMake(constrainedSize.max.width, 50)
        searchBarNode.preferredFrameSize = preferredSize
        let staticTextNodeSpec = ASStaticLayoutSpec(children: [searchBarNode])
        return  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(5, 0, 10, 0), child: staticTextNodeSpec)
    }
    
    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//    }
//
//
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchBar.setShowsCancelButton(false, animated: true)
//    }
}