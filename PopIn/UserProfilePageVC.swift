//
//  UserProfilePageVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/23/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AWSS3
import AWSMobileHubHelper
import AsyncDisplayKit
import SwiftyDrop

class UserProfilePageVC: ASViewController, ASTableDelegate, ASTableDataSource, HASearchBasicProfileCNDelegate {
    
    enum SectionType:String {
        case PhotoOnly  // Photo, real name
        case PhotoAndDetails  // Photo, real name
        case DetailsOnly = "Details" // Friends, following
        case PublicAlbumCount
    }
    
    
    var fetchingUserData = true
    var serverError = false
    
    
    let tableNode: ASTableNode
    var profileSectionHeader = [ SectionType.PhotoOnly, SectionType.DetailsOnly ]

    
    var userProfileModel: UserSearchModel
    
    
    init(withUserSearchModel model: UserSearchModel) {
        
        print("init:withUserModel")
        
        tableNode = ASTableNode(style: .Plain)
        userProfileModel = model
        super.init(node: tableNode)
        
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        print("UserProfilePageVC viewDidLoad")
        super.viewDidLoad()
        
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        
        
//        let bar:UINavigationBar! =  self.navigationController?.navigationBar
//        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        bar.shadowImage = UIImage()
//        bar.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.5, alpha: 0.3)
//        navigationController?.navigationBar.translucent = true
        
        navigationController?.hidesNavigationBarHairline = true
        
        
        navigationItem.title = userProfileModel.userName.uppercaseString
        
        
                
        userProfileModel.queryLambdaUserInfo { (success) in
            
            self.fetchingUserData = false
            
            self.serverError = !success
            
            self.reloadTable()
        }
    }
    
    func reloadTable() {
        
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            print("reload once")
            
            self.tableNode.view.reloadSections(NSIndexSet(index: 1),
                                               withRowAnimation: .None)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Need this after we upload media
        tabBarController?.tabBar.hidden = false
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - ASTableDataSource methods
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return profileSectionHeader.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return nil
//        }
//        return profileSectionHeader[section].rawValue
//    }
    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = UIColor.whiteColor()
        
        headerView.textLabel?.textAlignment = .Center
    }
    
    
    

    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        if indexPath.section == 0 {
            return {() -> ASCellNode in
                
                let cellNode = HAProfilePhotoCN(withProfileModel: self.userProfileModel)
                cellNode.selectionStyle = .None
                return cellNode
            }
        } else if indexPath.section == 1 && fetchingUserData {
            print("Fetching fetchingUserData")
            return {() -> ASCellNode in
                let cellNode = HALargeLoadingCN()
                cellNode.selectionStyle = .None
                return cellNode
            }
        } else if indexPath.section == 1 && !serverError {
            
            return {() -> ASCellNode in
                let cellNode = HASearchBasicProfileCN(withProfileModel: self.userProfileModel)
                cellNode.delegate = self
                cellNode.selectionStyle = .None
                return cellNode
            }
            
        } else {
            print("Fetching else")
            return {() -> ASCellNode in
                let cellNode = HASearchBasicProfileCN(withProfileModel: self.userProfileModel)
                cellNode.delegate = self
                cellNode.selectionStyle = .None
                return cellNode
            }
        }
    }
    
    func showErrorMessage(messsage: String) {
        
        Drop.down(messsage,
                  state: .Error ,
                  duration: 3.0,
                  action: nil)
    }
}


