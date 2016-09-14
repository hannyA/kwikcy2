//
//  HANotificationVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit
import SwiftyDrop


class HANotificationVC: ASViewController, ASTableDelegate, ASTableDataSource, HANotificationCellNodeDelegate {
    
    enum TableViewSection {
        case Messages
        case Notifications
    }
    
    let tableNode: ASTableNode
    let notificationFeed = HANotificationFeed()
    var hasMessageNodeShowing = false
    let refreshControl = UIRefreshControl()

    
    init() {
        print("HANotificationVC init")
        tableNode = ASTableNode(style: .Plain)
       
        super.init(node: tableNode)
        navigationItem.title = "Notifications"

        
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let AUTO_TAIL_LOADING_NUM_SCREENFULS:CGFloat = 2.5
    
    override func loadView() {
        super.loadView()
        
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        refreshControl.tintColor = UIColor.flatRedColor()
        refreshControl.addTarget(self,
                                 action: #selector(refreshTable),
                                 forControlEvents: .ValueChanged)
        tableNode.view.addSubview(refreshControl)
        tableNode.view.sendSubviewToBack(refreshControl)
        tableNode.view.leadingScreensForBatching = AUTO_TAIL_LOADING_NUM_SCREENFULS;  // overriding default of 2.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasMessageNodeShowing = true
//        refreshControl.beginRefreshing()
//        refreshTable(refreshControl)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl.beginRefreshing()
        refreshTable(refreshControl)
    }
    
 
    
    func refreshTable(refreshControl: UIRefreshControl) {
        print("refreshTable refreshControl")

        if hasMessageNodeShowing {
            self.tableNode.view.beginUpdates()
            reloadMessageNode()
            self.tableNode.view.endUpdates()
        }
        
        notificationFeed.queryLambdaNotifications(refreshNotifications: true) { (hasNewMessages, delete, insert, reload) in
            
            
            refreshControl.endRefreshing()
            
            print("returned queryLambdaNotifications")
            
            self.tableNode.view.beginUpdates()
        
        
            var firstTimeLoading = false
            if hasNewMessages {
                if self.hasMessageNodeShowing {
                    print("yes sir")
                    firstTimeLoading = true
                    self.deleteMessageNode()
                }
                
                if let deleteRows = delete {
                    
                    var rowsToDelete = [NSIndexPath]()
                    for row in deleteRows {
                        
                        rowsToDelete.append( NSIndexPath(forRow: row, inSection: 0) )
                    }
                    
                    self.tableNode.view.deleteRowsAtIndexPaths(rowsToDelete, withRowAnimation: .Left)
                }
                
                if let insertRows = insert {
                    
                    var rowsToInsert = [NSIndexPath]()
                    for row in insertRows {
                        
                        print("Inserting row at index: \(row)")
                        rowsToInsert.append( NSIndexPath(forRow: row, inSection: 0) )
                    }
                    
                    self.tableNode.view.insertRowsAtIndexPaths(rowsToInsert,
                                                               withRowAnimation: firstTimeLoading ? .Top : .Right )
                }
                
                if let reloadRows = reload {
                    
                    var rowsToReload = [NSIndexPath]()
                    for row in reloadRows {
                        
                        rowsToReload.append( NSIndexPath(forRow: row, inSection: 0) )
                    }
                    
                    self.tableNode.view.reloadRowsAtIndexPaths(rowsToReload, withRowAnimation: .None)
                }
                
            } else if self.hasMessageNodeShowing {
                self.reloadMessageNode()
            }
            self.tableNode.view.endUpdates()
        }
    }
    
    
    func reloadMessageNode() {        // "Getting Notifications"
        let row = 0, section = 0
        self.tableNode.view.reloadRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: section)],
                                                   withRowAnimation: .None)
    }
    
    func deleteMessageNode() {
        hasMessageNodeShowing = false
        let row = 0, section = 0
        self.tableNode.view.deleteRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: section)],
                                                   withRowAnimation: .None)
    }
    
    
    func insertNewRowsInTableView(count: Int ) {
        
        let section = 0
        var indexPaths = [NSIndexPath]()

        let newTotalNumberOfItems = notificationFeed.numberOfItemsInFeed()
        let startingIndex = newTotalNumberOfItems - count
        for row in startingIndex..<newTotalNumberOfItems {
            indexPaths.append(NSIndexPath(forRow: row,
                inSection: section))
        }
        self.tableNode.view.insertRowsAtIndexPaths(indexPaths,
                                                   withRowAnimation: .None)
    }
    
    
    
    //MARK: - ASTableDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return !notificationFeed.isEmpty() ? notificationFeed.numberOfItemsInFeed(): 1
   }
    
    
    
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
//        func notificationCN() -> ASCellNodeBlock {
//                   }
        
        
        if hasMessageNodeShowing {
            if refreshControl.refreshing {
                return {() -> ASCellNode in
                    let cell = SimpleCellNode(withMessage: "Getting Notifications")
                    cell.selectionStyle = .None
                    cell.userInteractionEnabled = false
                    return cell
                }
            } else {
                return {() -> ASCellNode in
                    let cell = SimpleCellNode(withMessage: "No New Messages")
                    cell.selectionStyle = .None
                    cell.userInteractionEnabled = false
                    return cell
                }
            }
        }
        else {
            let notificationObject = notificationFeed.objectAtIndex(indexPath.row)
            let actionButtonInfo = notificationObject.imageForNotificationType()

            print("OBject is \(notificationObject.id)")
            return {() -> ASCellNode in
                let cell = HANotificationCellNode(withNotificationObject: notificationObject,
                                                  buttonInfo: actionButtonInfo)
                cell.delegate = self
                cell.selectionStyle = .None
                return cell
            }
        }
    }
    
    
    
    
    func reloadRowForNotification(notification: HANotificationModel) {
        
        
        if let index = notificationFeed.indexOfNotificationModel(notification) {
        
            let section = 0
            
            tableNode.view.beginUpdates()
            let indexPath = NSIndexPath(forRow: index,
                                        inSection: section)
            tableNode.view.reloadRowsAtIndexPaths([indexPath],
                                                  withRowAnimation: .None)
            tableNode.view.endUpdates()
        }
    }
    
    
    
    func deleteRowForNotification(notification: HANotificationModel) {
        
        if let index = notificationFeed.indexOfNotificationModel(notification) {
        
            let section = 0
            
            tableNode.view.beginUpdates()
            let indexPath = NSIndexPath(forRow: index,
                                        inSection: section)
            tableNode.view.deleteRowsAtIndexPaths([indexPath],
                                                  withRowAnimation: .Left)
            tableNode.view.endUpdates()
        }
    }
        
    
    
    
    
    func showUserProfile(userModel: UserSearchModel) {
        
        let userProfileVC = UserProfilePageVC(withUserSearchModel: userModel)
        userProfileVC.navigationItem.title = userModel.userName.uppercaseString
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func showErrorMessage(messsage: String) {
    
        Drop.down(messsage,
                  state: .Error ,
                  duration: 2.0,
                  action: nil)
    }
}


