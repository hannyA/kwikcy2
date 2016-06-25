//
//  HAAlbumMediaShareVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import UIKit
import AsyncDisplayKit
import MobileCoreServices


// Select albums to add the new media to
class HAAlbumMediaShareVC: ASViewController, ASTableDelegate, ASTableDataSource {

    
    let image: UIImage?
//    let video: Type?
    let tablenode: ASTableNode

    init(withImage _image: UIImage) {
        
        image = _image
        tablenode = ASTableNode(style: .Plain)
        
        super.init(node: tablenode)
        
        navigationItem.title = "ADD"
        tablenode.dataSource = self
        tablenode.delegate = self
        navigationController?.navigationBarHidden = false

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Add to" // works
        
        tablenode.view.allowsSelection = false
        tablenode.view.separatorStyle = .None
    }
    
    
    
    //MARK: - ASTableDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
//        //If no albums
//        if feedModel.totalNumberOfAlbums() == 0 {
//            return  {() -> ASCellNode in
//                return SimpleCellNode(withMessage: "Go Make some friends")
//            }
//        }
//        
//        // If albums exist
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
        
        // this may be executed on a background thread - it is important to make sure it is thread safe
        return {() -> ASCellNode in
            return SimpleCellNode(withMessage: "help")
        }
    }
    
    
    

    
    
    
    
    
    
}