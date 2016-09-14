//
//  HAPushNotificationsVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit
import AWSMobileHubHelper

class HAPushNotificationsVC: ASViewController, ASTableDelegate, ASTableDataSource {
    
    
    let kPushNotificationType  = "PushNotificationType";
    let kPushNotificationValue = "PushNotificationValue";

    enum PushNotificationType: String {
        case NewFriends      = "newFriends"
        case NewMedia        = "newMedia"
        case AcceptedFriends = "acceptedFriends"
    }
    

    let newFriendText       = "New Friend Requests"
    let acceptedFriendsText = "Accepted Friend Requests"
    let newContentText      = "New Media Content"
   
    
    struct PushNotificationSettings {
        var newFriends      : Bool
        var acceptedFriends : Bool
        var newMedia        : Bool
    }
    
    let tableNode: ASTableNode
    var data = [[String]]()
    
    // Get this data from users AWS cloud settings
    var notifUpdates:PushNotificationSettings?
    
    
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
        
        let defaults = NSUserDefaults.standardUserDefaults()
      
        let guid = Me.sharedInstance.guid()!

        
        let newFriends              = defaults.boolForKey("\(guid)\(PushNotificationType.NewFriends.rawValue)")
        let acceptedFriendsRequests = defaults.boolForKey("\(guid)\(PushNotificationType.AcceptedFriends.rawValue)")
        
        let newMediaContent = defaults.boolForKey("\(guid)\(PushNotificationType.NewMedia.rawValue)")
        
        notifUpdates = PushNotificationSettings(newFriends: newFriends,
                                                acceptedFriends: acceptedFriendsRequests,
                                                newMedia: newMediaContent)
    }
    
    
    
    
    
    func saveSettings() {
        
    }
    //MARK: - ASTableDataSource methods
    
    
    func setup() {
        
        var rows = [String]()
        rows.append("FRIENDS")
        rows.append(newFriendText)
        rows.append(acceptedFriendsText)
        data.append(rows)
        
        rows = [String]()
        rows.append("CONTENT")
        rows.append(newContentText)
        rows.append("janeappleseed posted a new album")
        data.append(rows)
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
            
            if indexPath.section == 1 && indexPath.row == 2 {  // footer?
                
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
                    image = notifUpdates!.newFriends ? selectedImage : unselectedImage
                    
                } else { // if indexPath.row == 2 {
                    image = notifUpdates!.acceptedFriends ? selectedImage : unselectedImage
                }
            } else { // if indexPath.section == 1 && indexPath.row == 1  {
                image = notifUpdates!.newMedia ? selectedImage : unselectedImage
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
    
    
    func pushNotificationSettings(onCompletion closure: (activeStatus: UserActiveStatus?, errorMessage: String?) ->() ){
    }

    
    func updatePushNotification(type: String, turnOn isOn: Bool, onCompletion closure: (activeStatus: UserActiveStatus?, didUpdate :Bool, isOn: Bool?, errorMessage: String?) ->() ){

        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kAcctId]  = Me.sharedInstance.acctId()
        jsonObj[kPushNotificationType]  = type
        jsonObj[kPushNotificationValue] = isOn
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaUpdatePushNotificationSettings,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("refreshFeedWithCompletionBlock - Result: \(result)")
                    
                    if let response = PushNotificationUpdateResponse(response: result) {
                        
                        closure(activeStatus: response.userActiveStatus,
                                didUpdate   : response.success,
                                isOn        : response.updatedValue,
                                errorMessage: response.errorMessage)
                    } else {
                        
                        closure(activeStatus: nil,
                                didUpdate   : false,
                                isOn        : nil,
                                errorMessage: AWSErrorBackend)
                    }
                })
            }
            if let _ = AWSConstants.errorMessage(error) {
                dispatch_async(dispatch_get_main_queue(), {
                   
                    closure(activeStatus: nil,
                            didUpdate   : false,
                            isOn        : nil,
                            errorMessage: AWSErrorBackend)
                })
            }
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
                    
                    
                    updatePushNotification(PushNotificationType.NewFriends.rawValue, turnOn: !notifUpdates!.newFriends ,  onCompletion: { (userActiveStatus, didUpdate, isOn, errorMessage) in
                        
                        cellNode.returnedNetworkCall()

                        if didUpdate {
                            
                            self.notifUpdates!.newFriends = isOn!
                            
                            NSUserDefaults.standardUserDefaults().setBool(self.notifUpdates!.newFriends,
                                forKey: PushNotificationType.NewFriends.rawValue)
                        }
                       
                        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                            
                            if self.notifUpdates!.newFriends {
                                cellNode.resetRightImage(selectedImage, color: UIColor.flatGreenColor())
                            } else {
                                cellNode.resetRightImage(unselectedImage, color: UIColor.grayColor())
                            }
                        }, completion: nil)
                    })
                }
            case 2:
                
                let cellNode = tableNode.view.nodeForRowAtIndexPath(indexPath) as! HARadioCN
                
                if cellNode.userInteractionEnabled {
                    
                    cellNode.makingNetworkCall()
                    
                    updatePushNotification(PushNotificationType.AcceptedFriends.rawValue,
                        turnOn: !notifUpdates!.acceptedFriends ,
                        onCompletion: { (userActiveStatus, didUpdate, isOn, errorMessage) in
                        
                        cellNode.returnedNetworkCall()
                        
                        if didUpdate {
                            
                            self.notifUpdates!.acceptedFriends = isOn!
                            
                            NSUserDefaults.standardUserDefaults().setBool(self.notifUpdates!.acceptedFriends,
                                forKey: PushNotificationType.AcceptedFriends.rawValue)
                        }
                        
                        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                            
                            if self.notifUpdates!.acceptedFriends {
                                cellNode.resetRightImage(selectedImage, color: UIColor.flatGreenColor())
                            } else {
                                cellNode.resetRightImage(unselectedImage, color: UIColor.grayColor())
                            }
                            
                        }, completion: nil)
                    })
                }
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 1:
                
                let cellNode = tableNode.view.nodeForRowAtIndexPath(indexPath) as! HARadioCN
                
                
                if cellNode.userInteractionEnabled {
                    
                    cellNode.makingNetworkCall()
                    
                    updatePushNotification(PushNotificationType.NewMedia.rawValue,
                       turnOn: !notifUpdates!.newMedia ,
                       onCompletion: { (userActiveStatus, didUpdate, isOn, errorMessage) in
                        
                        cellNode.returnedNetworkCall()
                        
                        if didUpdate {
                            
                            self.notifUpdates!.newMedia = isOn!
                            
                            NSUserDefaults.standardUserDefaults().setBool(self.notifUpdates!.newMedia,
                                forKey: PushNotificationType.NewMedia.rawValue)
                        }
                        
                        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                            
                            if self.notifUpdates!.newMedia {
                                cellNode.resetRightImage(selectedImage, color: UIColor.flatGreenColor())
                            } else {
                                cellNode.resetRightImage(unselectedImage, color: UIColor.grayColor())
                            }
                            
                        }, completion: nil)
                    })
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
    