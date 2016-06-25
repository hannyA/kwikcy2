//
//  UserProfilePageVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/23/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class UserProfilePageVC: ASViewController, ASTableDelegate, ASTableDataSource {
    
    enum SectionType:String {
        case BasicDetails  // Photo, real name
        case SocialStatus // Friends, following
        case About // Text Description, username
        case PublicAlbumCount
    }
    
    

    
    
    let tableNode: ASTableNode
    var profileSectionHeader:[String] = [ SectionType.BasicDetails.rawValue]
//        ,SectionType.SocialStatus.rawValue]
//    var profileSections:[String: AnyObject]
    var profileModel: ProfileModel

    
    
    
  
    init(withUserModel model: UserModel) {
        
        print("init:withUserModel")
        tableNode = ASTableNode(style: .Plain)
        
//        profileSectionHeader = [String]()
//        profileSections = [String: AnyObject]()
        
    
        
        
        
        profileModel = ProfileModel(withUser: model)
        
        
        
        super.init(node: tableNode)
        
        tableNode.delegate = self
        tableNode.dataSource = self
        

//        let moreUserDetails = moreDetailsforUserWithId(model.userId!)
//        
//        profileSectionHeader.append("picture")  // Includes fullname
//        profileSectionHeader.append("about")
//        profileSectionHeader.append("albumCount")
      
//        
//        profileSections["Userpic"] =  moreUserDetails.userTestPic
//        profileSections["Username"] =  moreUserDetails.username
//
//        profileSections["about"] =  moreUserDetails.about
//        profileSections["albumCount"] =  moreUserDetails.albumCount
//        profileSections["fullName"] =  moreUserDetails.fullName

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        
        navigationItem.title = profileModel.user.userName?.uppercaseString
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
        navigationController?.hidesBarsOnSwipe = false
    }
    
    
    func moreDetailsforUserWithId(userid: String) -> UserModel {
        
        let dict = ["about": 1, "albumCount": 2, "fullName": "John Dog"]
        let newUserModel = UserModel(withUser: dict)
        
        return newUserModel
    }
    
    
    
    //MARK: - ASTableDataSource methods
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return profileSectionHeader.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return nil }
        return profileSectionHeader[section]
    }
    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = UIColor.whiteColor()
        
        headerView.textLabel?.textAlignment = .Center
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
//        let sectionHeadTitle = profileSectionHeader[section]
//        
//        switch sectionHeadTitle {
//        case "picture":
//            return 1
//        case "fullname":
//            return 1
////        case "albumCount":
////            return profileSections["albumCount"] as! Int
//        default:
//            return 1
//        }
    }
    
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        return {() -> ASCellNode in
            let cellNode = HASimpleUserDetailCN(withProfileModel: self.profileModel)
            cellNode.selectionStyle = .None
            return cellNode
        }
        
        

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
//        
        
//        if indexPath.row == 0 {
//            
//        }
        
    }

    
}


