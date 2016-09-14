//
//  AccountsVC.swift
//  PopIn
//
//  Created by Hanny Aly on 7/9/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit
import FBSDKLoginKit
import AWSMobileHubHelper
import SwiftyDrop


class HAAccountsVC: ASViewController, ASTableDelegate, ASTableDataSource {
    
    
    let tableNode: ASTableNode
    var data: [[String]] = [[String]]()
    
    
    var myVerification: Bool?
    
    init() {
        
        tableNode = ASTableNode(style: .Plain)

        super.init(node: tableNode)
        
        tableNode.view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        
        tableNode.dataSource = self
        tableNode.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let verificationIconColor = UIColor.flatBlueColor()
    let unverificationIconColor = UIColor.flatGrayColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myVerification = Me.sharedInstance.verified()
//        
//        let verificationImage = NSAttributedString.titleNodeIcon(from: .MaterialIcon,
//                                                                    code: "verified.user",
//                                                                    ofSize: kTextSizeRegular,
//                                                                    color: verificationIconColor)
//        
////        let convertedString = verificationAttrText.string
//        
//        
//        let first = NSAttributedString(string: "This will give you the verification symbol (",
//                                   fontSize: kTextSizeRegular,
//                                   color: UIColor.blackColor(),
//                                   firstWordColor: nil)
//        
//        
//        let end = NSAttributedString(string: ") next to your username if you've been verified by Facebook ",
//                                   fontSize: kTextSizeRegular,
//                                   color: UIColor.blackColor(),
//                                   firstWordColor: nil)
//        
//
//        let verificationText = NSMutableAttributedString(attributedString: first)
//        
//        verificationText.appendAttributedString(verificationImage)
//        verificationText.appendAttributedString(end)
//        
//        
        

        
        
        title = "Accounts"
        
//        let title = 
        var rows = [String]()
        rows.append("")
        rows.append("Verify your identity through Facebook.")
        rows.append("This will place a verification symbol")
        data.append(rows)

        
        rows = [String]()
        rows.append("")
        rows.append("Delete Account")
        rows.append("Revoke Facebook permissions, delete all data, friendships, and username")
        data.append(rows)
        
        
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        tableNode.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    
    let HEADER = 0, FOOTER = 2
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        
        
        let title = data[indexPath.section][indexPath.row]

        if indexPath.row == HEADER {
            let textNode = HASettingCN(withTitle       : title,
                                       isHeader        : true,
                                       hasTopDivider   : false, //indexPath.section == 0 ? false :  true,
                                       hasBottomDivider: indexPath.section == data.count-1 ? false :  true)
            
            textNode.selectionStyle = .None
            textNode.userInteractionEnabled = false
            return textNode
            
        }
        
        if indexPath.row == FOOTER {
            
            if indexPath.section == 0 { // first section
                
                let verificationImage = NSAttributedString.titleNodeIcon(from: .MaterialIcon,
                                                                         code: "verified.user",
                                                                         ofSize: kTextSizeXS,
                                                                         color: verificationIconColor)

                let cellNode = HAFooterCN(withLeftTitle: "This will give you the verification symbol (",
                                          verificationString: verificationImage,
                                          rightTitle: ") next to your username if you've been verified by Facebook ",
                                          hasTopDivider: true,
                                          hasBottomDivider: false)
                
                cellNode.selectionStyle = .None
                cellNode.userInteractionEnabled = false
                return cellNode
            
            } else { // second section
                
                let cellNode = HAFooterCN(withTitle: title,
                                          hasTopDivider: true,
                                          hasBottomDivider: false)
                cellNode.selectionStyle = .None
                cellNode.userInteractionEnabled = false
                return cellNode
            }
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
        

        
        
        let image =  (myVerification ?? false) ? selectedImage : unselectedImage
        
        let cellNode = HARadioCN(withTitle: title,
                             rightImage: image,
                             hasTopDivider: indexPath.row == 1 ? false :true,
                             hasBottomDivider: false)
        cellNode.backgroundColor = UIColor.whiteColor()
        cellNode.selectionStyle = .None
        return cellNode
    }
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        print("didSelectRowAtIndexPath: \(indexPath.row)")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
        

        
        if indexPath.row == 1 {
            switch indexPath.section {
            case 0:
                print("Verifying account")
                
                let cellNode = tableNode.view.nodeForRowAtIndexPath(indexPath) as! HARadioCN
                
                if cellNode.isNotMakeingNetworkCall() {
                    
                    cellNode.makingNetworkCall()
                    
                    handleVerification(onCompletion: { (activeStatus, didUpdate, isVerified, errorMessage) in
                        
                        cellNode.returnedNetworkCall()
                        
                        if didUpdate {
                            
                            if isVerified == true {
                                self.alertUser(self.normalFacebookTitle, message: "Facebook Verification is set")
                            } else {
                                self.alertUser(self.normalFacebookTitle, message: "You haven't been verified by Facebook. If this is an error, let us know")
                            }
                            
                            
                            self.myVerification = isVerified
                            
                            Me.sharedInstance.saveVerification(isVerified!)
                        } else {
                            self.alertUser(self.errorFacebookTitle, message: errorMessage!)
                        }
                        
                        
                        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                            
                            if self.myVerification! {
                                cellNode.resetRightImage(selectedImage, color: UIColor.flatGreenColor())
                            } else {
                                cellNode.resetRightImage(unselectedImage, color: UIColor.grayColor())
                            }
                        }, completion: nil)
                    })

                }

            case 1:
                print("Deleting account")
                requestDeleteAccount()
            default: break
            }
        }
    }
    
    func handleVerification(onCompletion closure: (activeStatus: UserActiveStatus?, didUpdate :Bool, isVerified: Bool?, errorMessage: String?) ->()) {
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]          = Me.sharedInstance.guid()
        jsonObj[kAcctId]        = Me.sharedInstance.acctId()
        jsonObj[kFacebookToken] = FBSDKAccessToken.currentAccessToken().tokenString
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaFacebookVerify,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("uploadMedia: CloudLogicViewController: Result: \(result)")
                    
                    if let response = UpdatedBoolResponse(response: result) {
                        
                        
                        closure(activeStatus: response.userActiveStatus,
                            didUpdate: response.success,
                            isVerified: response.updatedValue,
                            errorMessage: response.errorMessage)
                        
                        if response.userActiveStatus == .Active {
                            
                            if response.success {
                                
                                closure(activeStatus: response.userActiveStatus,
                                    didUpdate: true,
                                    isVerified: response.updatedValue,
                                    errorMessage: response.errorMessage)
                                
                            } else {
                                
                                closure(activeStatus: response.userActiveStatus,
                                    didUpdate: false,
                                    isVerified: response.updatedValue,
                                    errorMessage: response.errorMessage ?? AWSErrorBackend)
                            }
                        } else {
                            
                            // Log user out
                        }
                        
                    } else {
                        
                        closure(activeStatus: nil,
                            didUpdate: false,
                            isVerified: nil,
                            errorMessage: "Cannot verify you at this time. Try again shortly")
                        
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                print("facebook verification: failed")
                dispatch_async(dispatch_get_main_queue(), {
                    
                    closure(activeStatus: nil,
                        didUpdate: false,
                        isVerified: nil,
                        errorMessage: AWSErrorBackend)
                })
            }
        }
    }
    
    let normalFacebookTitle = "Facebook Verification"
    let errorFacebookTitle  = "Facebook Verification Error"
    
    func alertUser(title: String, message: String) {
        
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .Alert )
        let okAction = UIAlertAction(title: "OK",
                                     style: .Default) { (defaultAction) in
            
            
        }
        alertController.addAction(okAction)

        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    func requestDeleteAccount() {
        
        let alertController = UIAlertController(title: "Deleting Account",
                                                message: "You are about to delete your account, all your content and revoke Facebook permissions. Are you sure?",
                                                preferredStyle: .Alert )
        
        let deleteAccount = UIAlertAction(title: "Yes",
                                        style: .Destructive) { (defaultAction) in
            self.handleDeleteAccount()
        }
        alertController.addAction(deleteAccount)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    
    
    
    
    
    
    
    
    
    
    
    
    func handleDeleteAccount() {
        
        deleteAccount()
    }
    
    
    func deleteAccount() {
        
        var jsonObj = [String: AnyObject]()
        
        jsonObj[kGuid]      = Me.sharedInstance.guid()
        jsonObj[kAcctId]    = Me.sharedInstance.acctId()
        
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaDeleteAccount,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("delete account : CloudLogicViewController: Result: \(result)")
                    
                    if let response = ActiveResponse(response: result) {
                     
                        if response.userActiveStatus != .Active {
                            
                            self.revokeFacebookPermissions()
                        
                        } else if let errorMessage = response.errorMessage {
                            
                            Drop.down(errorMessage,
                                state: .Error ,
                                duration: 5.0,
                                action: nil)
                            
                        } else {
                            
                            Drop.down(AWSErrorBackend,
                                state: .Error ,
                                duration: 5.0,
                                action: nil)
                        }
                    } else {
                        Drop.down(AWSErrorBackend,
                            state: .Error ,
                            duration: 5.0,
                            action: nil)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                print("delete account: failed")
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    Drop.down(AWSErrorBackend,
                        state: .Error ,
                        duration: 5.0,
                        action: nil)
                })
            }
        }
    }

    
    
    
    
    // If we get to this point, the account has already been deleted, so may as well continue
    func revokeFacebookPermissions() {
        print("revokeFacebookPermissions")
        
        let facebookRequest = FBSDKGraphRequest(graphPath: "/me/permissions",
                                                parameters: nil,
                                                tokenString: FBSDKAccessToken.currentAccessToken().tokenString,
                                                version: nil,
                                                HTTPMethod: "DELETE")
        
        facebookRequest.startWithCompletionHandler { (graphRequestConnection, result, error) in
            
            print("result: \(result), error\(error)")
            
            if let err = error {
                if let errorMessage = err.userInfo["error"] as? String {
                    print("errorMessage variable equals: \(errorMessage)")
                    
                } else {
                    print("Some error don't know")
                }
            } else {
                
                print("Successfull revoked permissions")
                
            }
            (self.tabBarController as? HATabBarController)?.logoutFacebookUser()
        }
    }
}

