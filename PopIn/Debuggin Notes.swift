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
 
 5) UIView.animateWithDuration returns to fast.
    Is the view layerBacked? That will use layers instead of views
    Are you using "alpha" instead of "hidden" propperty?
 
 
 
 
 
 
    TODO: List
 
    1) Add shared instance for my albums and my friends
    2) Add network activity
    3) iOS phone App images
 
 
 
 Ways to View
 
         This should all be set up in notifications
         If "dataing save mode" is on
         Optins will change to:
             1) save data on "friends messages"
             2) Save data on all data
             Split into Save data NSUserDefaults:
                 a) friends
                 b) public
         
         
         Use Realm for friends Albus
         User In-memory Realm for all other albums
         
        If saveDataMode == Off {
         
            1) Predownload all friends albums
       
        } else {
 
             2) Click album - Downloadload everything
             1) Auto open up
             2) User click again to open
             
             3) User clicks album - it opens up to loading screen but user
             
         }
 
 
         Every
         
         Design - For every cell ready to be opened change the 
         background of the cell to the Chameleon color of the user album
 

 
 
 
 */










