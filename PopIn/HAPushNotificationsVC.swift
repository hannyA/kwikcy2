//
//  HAPushNotificationsVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class HAPushNotificationsVC: ASViewController, ASTableDelegate, ASTableDataSource {
    
    
    struct NotifUpdate {
        var newFriends: Bool
        var acceptedFriends: Bool
        var newMedia: Bool
    }
    
    let tableNode: ASTableNode
    var data = [[String]]()
    
    // Get this data from users AWS cloud settings
    var notifUpdates = NotifUpdate(newFriends: false, acceptedFriends: false, newMedia: false)
    
    
    init() {
        
        tableNode = ASTableNode(style: .Plain)
        
        super.init(node: tableNode)
        
        tableNode.dataSource = self
        tableNode.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        super.loadView()
        
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        tableNode.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notifications"
        tableNode.view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        
        setup()
    }
    
    
    
    func saveSettings() {
        
    }
    //MARK: - ASTableDataSource methods
    
    
    let newFriendTitle  = "New Friend Requests"
    let acceptedFriends = "Accepted Friend Requests"
    let newContent      = "New Media Content"
   
    func setup() {
        
        var rows = [String]()
        rows.append("FRIENDS")
        rows.append(newFriendTitle)
        rows.append(acceptedFriends)
        data.append(rows)
        
        rows = [String]()
        rows.append("CONTENT")
        rows.append(newContent)
        rows.append("janeappleseed posted a new album")
        data.append(rows)
        
        // Footer
//        rows = [String]()
//        rows.append("")
//        data.append(rows)
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    let HEADER = 0
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        let textNode: HASettingCN
        let title = data[indexPath.section][indexPath.row]
        
        if indexPath.row == HEADER {
            textNode = HASettingCN(withTitle: title,
                                   isHeader: true,
                                   hasTopDivider: indexPath.section == 0 ? false :  true,
                                   hasBottomDivider: indexPath.section == data.count-1 ? false :  true)
            
            textNode.selectionStyle = .None
            textNode.userInteractionEnabled = false
            return textNode

        } else {
            
            if indexPath.section == 1 && indexPath.row == 2 {  // example
                
                let cellNode = HAFooterCN(withTitle: title,
                                          hasTopDivider: true,
                                          hasBottomDivider: false)
                cellNode.selectionStyle = .None
                cellNode.userInteractionEnabled = false
                return cellNode
            }
            
            
            let unselectedImage = UIImage.icon(from: .MaterialIcon,
                                             code: "radio.button.unchecked",
                                             imageSize: CGSizeMake(35, 35),
                                             ofSize: 35,
                                             color: UIColor.grayColor())
            
            let selectedImage   = UIImage.icon(from: .MaterialIcon,
                                             code: "check.circle",
                                             imageSize: CGSizeMake(35, 35),
                                             ofSize: 35,
                                             color: UIColor.flatGreenColor())
            
            let cellNode:HARadioCN
            let image:UIImage
            
            if indexPath.section == 0 {
                if indexPath.row == 1 {
                    
                    if notifUpdates.newFriends == true {
                        image = selectedImage
                    } else {
                        image = unselectedImage
                    }
                } else { // if indexPath.row == 2 {
                    if notifUpdates.acceptedFriends == true {
                        image = selectedImage
                    } else {
                        image = unselectedImage
                    }
                }
            } else { // if indexPath.section == 1 && indexPath.row == 1  {
                    
                if notifUpdates.newMedia == true {
                    image = selectedImage
                } else {
                    image = unselectedImage
                }
            }
            cellNode = HARadioCN(withTitle: title,
                                   rightImage: image,
                                   hasTopDivider: indexPath.row == 1 ? false :true,
                                   hasBottomDivider: false)
            
            cellNode.backgroundColor = UIColor.whiteColor()
            cellNode.selectionStyle = .None
            return cellNode
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("didSelectRowAtIndexPath")

        
        let unselectedImage = UIImage.icon(from: .MaterialIcon,
                                           code: "radio.button.unchecked",
                                           imageSize: CGSizeMake(35, 35),
                                           ofSize: 35,
                                           color: UIColor.grayColor())
        
        let selectedImage   = UIImage.icon(from: .MaterialIcon,
                                           code: "check.circle",
                                           imageSize: CGSizeMake(35, 35),
                                           ofSize: 35,
                                           color: UIColor.flatGreenColor())
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 1:
                
                let cellNode = tableNode.view.nodeForRowAtIndexPath(indexPath) as! HARadioCN
                
            
                if cellNode.userInteractionEnabled {
                    print("userInteractionEnabled")

                    cellNode.makingNetworkCall()
                    
                    print("Dispatch netowrk call")
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(kWebResponseDelayFast * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                        
                        self.notifUpdates.newFriends = !self.notifUpdates.newFriends

                        print("Returned from call")
                        cellNode.returnedNetworkCall()
                        
                        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {

            
                            if self.notifUpdates.newFriends {
                                cellNode.resetRightImage(selectedImage, color: UIColor.flatGreenColor())
                            } else {
                                cellNode.resetRightImage(unselectedImage, color: UIColor.grayColor())
                            }
                            
                        }, completion: nil)
                    }
                }
                
            case 2:
                
                let cellNode = tableNode.view.nodeForRowAtIndexPath(indexPath) as! HARadioCN
                
                
                if cellNode.userInteractionEnabled {
                    print("userInteractionEnabled")
                    
                    cellNode.makingNetworkCall()
                    
                    print("Dispatch netowrk call")
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(kWebResponseDelayFast * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                        
                        self.notifUpdates.acceptedFriends = !self.notifUpdates.acceptedFriends

                        
                        print("Returned from call")
                        cellNode.returnedNetworkCall()
                        
                        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                            
                            
                            if self.notifUpdates.acceptedFriends {
                                cellNode.resetRightImage(selectedImage, color: UIColor.flatGreenColor())
                            } else {
                                cellNode.resetRightImage(unselectedImage, color: UIColor.grayColor())
                            }
                            
                        }, completion: nil)
                    }
                }
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 1:
                
                let cellNode = tableNode.view.nodeForRowAtIndexPath(indexPath) as! HARadioCN
                
                
                if cellNode.userInteractionEnabled {
                    print("userInteractionEnabled")
                    
                    
                    cellNode.makingNetworkCall()
                    
                    print("Dispatch netowrk call")
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(kWebResponseDelayFast * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                        
                        self.notifUpdates.newMedia = !self.notifUpdates.newMedia

                        
                        print("Returned from call")
                        cellNode.returnedNetworkCall()
                        
                        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                            
                            
                            if self.notifUpdates.newMedia {
                                cellNode.resetRightImage(selectedImage, color: UIColor.flatGreenColor())
                            } else {
                                cellNode.resetRightImage(unselectedImage, color: UIColor.grayColor())
                            }
                            
                        }, completion: nil)
                    }
                }
            default:
                break
            }
        default:
            break
        }
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
}
    