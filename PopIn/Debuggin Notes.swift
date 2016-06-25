//
//  Debuggin Notes.swift
//  PopIn
//
//  Created by Hanny Aly on 6/15/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


/*
 
 1) Something doesn't show up: Did you use addSubnode(node)?
 
 2) Need to add a UIView Object? Refer to HATextField.swift
 
 3) Use height values greater than 50. At least 100. Sometimes views are hidden behind navigationbar
    Even if  navigationController?.navigationBarHidden = true and it still shows
    Use -
        newAlbumVC.edgesForExtendedLayout = .None
        newAlbumVC.extendedLayoutIncludesOpaqueBars = true
 
 4) Did you set delegate and datasources?
 
 
 
 
 
 
 
 
 */