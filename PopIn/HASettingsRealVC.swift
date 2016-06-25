//
//  HASettings.swift
//  PopIn
//
//  Created by Hanny Aly on 6/22/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



import AsyncDisplayKit

class HASettingsRealVC: ASViewController, ASTableDelegate, ASTableDataSource {
    
    
    let tableNode: ASTableNode
    var data: [[String]]

    
    init() {
        
        tableNode = ASTableNode(style: .Plain)
        
        data = HASettingsRealVC.setup()
        super.init(node: tableNode)
        
        tableNode.view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        
        tableNode.dataSource = self
        tableNode.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options"
        
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        tableNode.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    
    
    //MARK: - ASTableDataSource methods
    
    
    
    class func setup() -> [[String]] {
    
        var sections = [[String]]()
        
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
        rows.append("Notifications")
        rows.append("Data Usage")
        sections.append(rows)

        
        rows = [String]()
        rows.append("CONTACT US")
        rows.append("Report a problem")
        sections.append(rows)
        
        
        rows = [String]()
        rows.append("LEGAL")
//        rows.append("Privacy Policy")
//        rows.append("Terms")
        rows.append("Licenses")
        sections.append(rows)


        

        
        
        
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
        sections.append(rows)
        
        // Footer
        rows = [String]()
        rows.append("")
        sections.append(rows)

        
        return sections
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        let row = indexPath.row
        if row == 0 {
            
            let headerTitle = data[indexPath.section][indexPath.row]
            
            let textNode: HASettingCN
            if indexPath.section == data.count-1 {
                textNode = HASettingCN(withTitle: headerTitle, isHeader: true, hasDivider: false)
            } else {
                textNode = HASettingCN(withTitle: headerTitle, isHeader: true, hasDivider: true)
            }
            textNode.selectionStyle = .None
            textNode.userInteractionEnabled = false
            return textNode
        } else {
            
            let rowTitle = data[indexPath.section][indexPath.row]
            let textNode: HASettingCN
            if row == 1 {
                textNode = HASettingCN(withTitle: rowTitle, isHeader: false, hasDivider: false)
            } else {
                textNode = HASettingCN(withTitle: rowTitle, isHeader: false, hasDivider: true)
            }


            textNode.backgroundColor = UIColor.whiteColor()
            textNode.selectionStyle = .Gray
            

            return textNode
        }
        
    
//        let textNode = ASTextCellNode()
//        textNode.text = data[indexPath.section][indexPath.row]
//        return textNode
    }
    
//    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
//
//        if indexPath.section == 0 {
//            
//            return {() -> ASCellNode in
//                self.basicUserCellNode = BasicProfileCellNode(withProfileModel: self.profileModel, loggedInUser: true)
//                self.basicUserCellNode!.delegate = self
//                self.basicUserCellNode!.selectionStyle = .None
//                return self.basicUserCellNode!
//            }
//            
//        } else { // Section 2
//            
//            print("profileModel count \(profileModel.albumCount())")
//            // If albums exist
//            let album = profileModel.albumAtIndex(indexPath.row)
//            
//            return {() -> ASCellNode in
//                let albumCellNode = MyAlbumCN(withAlbumObject: album, atIndexPath: indexPath)
//                albumCellNode.selectionStyle = .None
//                albumCellNode.delegate = self
//                return albumCellNode
//            }
//        }
//    }
//    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("didSelectRowAtIndexPath: \(indexPath.row)")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        switch indexPath.section {
        case 0:
            switch row {
            case 1:
                print("Notifications")
                
                let notificationVC = HANotificationsVC()
                navigationController?.pushViewController(notificationVC, animated: true)
                
                
                
                
            case 2:
                print("Data Usage")

            default:
                print("Shouldn't be here")
            }
        case 1:
            switch row {
            case 1:
                print("Report a problem")
                reportAproblemOptions()
                
            default:
                print("Shouldn't be here")
            }
        case 2:
            switch row {
            case 1:
                print("Licenses")
            default:
                print("Shouldn't be here")
            }
        case 3:
            switch row {
            case 1:
                print("Rate the App")
            case 2:
                print("Log Out")
            default:
                print("Shouldn't be here")
            }
        default:
            print("Shouldn't be here")

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
    
    
    
    
    
    

    
}






