//
//  HASettings.swift
//  PopIn
//
//  Created by Hanny Aly on 6/22/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



import AsyncDisplayKit
import AWSMobileHubHelper

protocol HASettingsRealVCDelegate {
    func hideSelf()
}
class HASettingsRealVC: ASViewController, ASTableDelegate, ASTableDataSource {
    
    
    let tableNode: ASTableNode
    var data = [[String]]()

    
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
       
        setup()

        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        tableNode.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options"
        tableNode.view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        
    }
    
    
    //MARK: - ASTableDataSource methods
    
    
    
    func setup() {
        
        /* Will only include 
            Accounts - change username
            Notifications
            Data Usage? If easy
            Report a problem
            open source libraries/ Licenses
            Rate the app 
            Log out
         */
        
        var rows = [String]()
        rows.append("SETTINGS")
//        rows.append("Accounts")
        rows.append("Accounts")
        rows.append("Notifications")
        rows.append("Data Usage")
        data.append(rows)

        
        rows = [String]()
        rows.append("CONTACT US")
        rows.append("Report a problem")
        data.append(rows)
        
        
        rows = [String]()
        rows.append("LEGAL")
//        rows.append("Privacy Policy")
//        rows.append("Terms")
        rows.append("Licenses")
        data.append(rows)


        
//        var rows = [String]()
//        rows.append("Follow People")
//        rows.append("Find Facebook Friends")
//        rows.append("Invite Facebook Friends")
//        rows.append("Tell a Friend")
//        sections.append(rows)
//
//        // Settings
//        rows = [String]()
//        rows.append("Settings")
//        rows.append("Accounts") // List usernames in your account with edit button. change username, switch to, delete username
//        rows.append("Privacy")   // Allow facebook friends to find you, Block users, private account
//        rows.append("Notifications")
//        rows.append("Data Usage")
//        sections.append(rows)
//
//        // Support
//        rows = [String]()
//        rows.append("Support")
//        rows.append("FAQs")
//        rows.append("Help")
//        rows.append("Report a Problem")
//        sections.append(rows)
//        
//        // About
//        rows = [String]()
//        rows.append("About")
//        rows.append("Blog")
//        rows.append("Follow Us On Facebook")
//        rows.append("Follow Us On Twitter")
//        rows.append("Privacy Policy")
//        rows.append("Terms")
//        rows.append("Licenses")
//        sections.append(rows)

        
        rows = [String]()
        rows.append("")
        rows.append("Rate the App")
        rows.append("Log Out")
        data.append(rows)
        
        // Footer
        rows = [String]()
        rows.append("")
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
       
        } else {
            
            let arrow = UIImage.icon(from: .MaterialIcon,
                         code: "arrow.forward",
                         imageSize: CGSizeMake(30, 30),
                         ofSize: 30,
                         color: UIColor.blackColor())
            
            textNode = HASettingCN(withTitle: title,
                                   rightImage: arrow,
                                   isHeader: false,
                                   hasTopDivider: indexPath.row == 1 ? false :  true,
                                   hasBottomDivider: false)

            textNode.backgroundColor = UIColor.whiteColor()
            textNode.selectionStyle = .Gray
        }
        
        return textNode
    }
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("didSelectRowAtIndexPath: \(indexPath.row)")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        switch indexPath.section {
        case 0:
            switch row {
            case 1:
                
                print("Accounts")
                let accountsVC = HAAccountsVC()
                navigationController?.pushViewController(accountsVC, animated: true)

            case 2:
                print("Notifications")
                
                let notificationVC = HAPushNotificationsVC()
                navigationController?.pushViewController(notificationVC, animated: true)
                
            case 3:
                print("Data Usage")

                let dataUseVC = DataUsageVC()
                navigationController?.pushViewController(dataUseVC, animated: true)
            default:
                break
            }
        case 1:
            switch row {
            case 1:
                print("Report a problem")
                reportAproblemOptions()
                
            default:
                break
            }
        case 2:
            switch row {
            case 1:
                print("Licenses")
            default:
                break
            }
        case 3:
            switch row {
            case 1:
                print("Rate the App")
                
                UIApplication.sharedApplication().openURL(NSURL(string : iTunesLink)!)
            case 2:
                print("Log Out")
                handleLogout()
            default:
                break
            }
        default:
            break
        }
    }
    
    
    
    func reportAproblemOptions() {
        
        let alertController = UIAlertController(title: "Report a Problem", message: nil, preferredStyle: .Alert )
        let abuseAction = UIAlertAction(title: "Abuse", style: .Default) { (defaultAction) in
            
            let headline = "Spam or abuse"
            let message = "Tell us what's wrong"
            
            let contactVC = HAContactUsVC(headline: headline, message: message)
            let navCon = UINavigationController(rootViewController: contactVC)
            
            self.presentViewController(navCon, animated: true, completion: nil)
     
        
        }
        alertController.addAction(abuseAction)
        
        let bugContent = UIAlertAction(title: "Something isn't Working", style: .Default) { (defaultAction) in

            let headline = "Something isn't working"
            let message = "Briefly explain what happened."
            
            let contactVC = HAContactUsVC(headline: headline, message: message)
            let navCon = UINavigationController(rootViewController: contactVC)
            
            self.presentViewController(navCon, animated: true, completion: nil)

        }
        alertController.addAction(bugContent)
        
        let feedbackContent = UIAlertAction(title: "General Feedback", style: .Default) { (defaultAction) in
            print("General Feedback")
            
            let headline = "General Feedback"
            let message = "Tell us what you love, what you hate, or what you want changed"
            
            let contactVC = HAContactUsVC(headline: headline, message: message)
            let navCon = UINavigationController(rootViewController: contactVC)
           
            self.presentViewController(navCon, animated: true, completion: nil)
        }
        alertController.addAction(feedbackContent)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func openVCAtIndex(index: NSIndexPath) {
        
    }
    
    
    func handleLogout() {
        if AWSIdentityManager.defaultIdentityManager().loggedIn {
            
            AWSIdentityManager.defaultIdentityManager().logoutWithCompletionHandler({(result: AnyObject?, error: NSError?) -> Void in
                
                print("Result: \(result)")
                print("Error: \(error)")
                
                if let errorMessage = AWSConstants.errorMessage(error) {
                    
                    print("errorMessage: \(errorMessage)")
                }
                
                Me.wipeData()
                
                self.presentSignInViewController()
            })
        } else {
            assert(false)
            //Show could not log out...
        }
    }

    
    
    
    func presentSignInViewController() {
        print("presentSignInViewController")
        
        if !AWSIdentityManager.defaultIdentityManager().loggedIn {
            print("!AWSIdentityManager.defaultIdentityManager().loggedIn ")

            
            
            presentViewController(SignInVC(), animated: false, completion: {
                
                self.tabBarController?.selectedIndex = 0
                
                self.navigationController?.popViewControllerAnimated(false)
            })
        }
    }
    
}






