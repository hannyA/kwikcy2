//
//  HANotificationVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class HANotificationVC: ASViewController, ASTableDelegate, ASTableDataSource, HANotificationCellNodeDelegate {
    
    enum TableViewSection {
        case Messages
        case Notifications
    }
    
    let tableNode: ASTableNode
    
    var notificationModel: HATESTNotification
    
    var profileModel: ProfileModel

    
    
    
    
    init() {
        
        
        let userModel = TESTFullAppModel(numberOfUsers: 1).firstUser()
       
        profileModel = ProfileModel(withUser: userModel!)
        notificationModel = HATESTNotification()
        
        tableNode = ASTableNode(style: .Plain)
        
        
        super.init(node: tableNode)
        
        title = "Notifications"
        
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        tableNode.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    
    
    
    
    //MARK: - ASTableDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationModel.count()
    }
    
    
    
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        
        let notificationObject = notificationModel.atIndex(indexPath.row)
        return {() -> ASCellNode in
            let cell = HANotificationCellNode(withNotificationObject: notificationObject)
            cell.delegate = self
            cell.selectionStyle = .None
            return cell
        }
    }
    
    func showUserProfile(userModel: UserModel) {
        
        let userProfileVC = UserProfilePageVC(withUserModel: userModel)
        userProfileVC.navigationItem.title = userModel.userName?.uppercaseString
        
        print("\(userModel.userName?.uppercaseString)")
        
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    
}


