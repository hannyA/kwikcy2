//
//  HACameraVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/19/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

//import Foundation

import AsyncDisplayKit



class HACameraVC: ASViewController, ASTableDelegate, ASTableDataSource, ASCollectionDelegate, HACameraNavigationDelegate {
    
    let tableNode: ASTableNode
    var aimageView: UIImageView?
    var cameraNavigation: HACameraNavigationNode?
    var controllerPage: HACameraControlsPagerVC?
    
    
    
    func didCancelCamera() {
        print("didCancelCamera")
        navigationController?.popViewControllerAnimated(true)
    }
    
    func moveToNextVC() {
        print("moveToNextVC")
        
    }
    
    
    
    
//    let cameraNavigator: HACameraNavigation
//    let cameraPagerVC: HACameraPagerVC

    
    init() {
        
        tableNode = ASTableNode(style: .Plain)
        super.init(node: tableNode)
        
        
        tableNode.dataSource = self
        tableNode.delegate = self        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CameraKer"
        
        tableNode.view.allowsSelection = false
        tableNode.view.separatorStyle = .None
        tableNode.view.scrollEnabled = false
        
//        navigationController?.navigationBarHidden = true
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // Tablenode Delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        switch indexPath.row {
            case 0:
                cameraNavigation = HACameraNavigationNode(leftText: "Cancel", middleText: "Camera Roll", rightText: "Next")
                cameraNavigation!.delegate = self
                return cameraNavigation!
            
            case 1: return HACameraViewNode()
            case 2:
                let frame = CGRectMake(0, 0, tableView.bounds.width , 200)
                controllerPage = HACameraControlsPagerVC(withFrame: frame)
//                controllerPage!.pagerNode.delegate = self
            return controllerPage!
            case 3: return HACameraPagerControllerNode()
            default: return HACameraPagerControllerNode()
        }
    }
    
    
    
    
    
    
//    let photo: UIImage
////    let video: 
//    
    //    init(with)
//    
//    init(withPhoto image: UIImage) {
//        
//        photo = image
//
//      
    
    
}