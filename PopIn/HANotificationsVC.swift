//
//  HANotificationsVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class HANotificationsVC: ASViewController, ASTableDelegate, ASTableDataSource {
    
    
    let tableNode: ASTableNode
    var data: [[String]]
    
    
    init() {
        
        tableNode = ASTableNode(style: .Plain)
        
        data = HANotificationsVC.setup()
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
        
        title = "Notifications"
        
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        tableNode.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    
    
    //MARK: - ASTableDataSource methods
    
    
    
    class func setup() -> [[String]] {
        
        var sections = [[String]]()
        
        
        var rows = [String]()
        rows.append("FRIENDS")
        rows.append("New Friend Requests")
        rows.append("Friend Request Accepted")
        sections.append(rows)
        
        
        rows = [String]()
        rows.append("CONTENT")
        rows.append("New Media Content")
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
            let switchCN: HASwitchCN
            if row == 1 {
                switchCN = HASwitchCN(withTitle: rowTitle, isHeader: false, hasDivider: false)
            } else {
                switchCN = HASwitchCN(withTitle: rowTitle, isHeader: false, hasDivider: true)
            }
            
            switchCN.selectionStyle = .None
            switchCN.backgroundColor = UIColor.whiteColor()            
            
            return switchCN
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
    
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        print("didSelectRowAtIndexPath: \(indexPath.row)")
//        
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        
//        let row = indexPath.row
//        switch indexPath.section {
//        case 0:
//            switch row {
//            case 1:
//                print("Notifications")
//            case 2:
//                print("Data Usage")
//                
//            default:
//                print("Shouldn't be here")
//            }
//        case 1:
//            switch row {
//            case 1:
//                print("Report a problem")
//                reportAproblemOptions()
//                
//            default:
//                print("Shouldn't be here")
//            }
//        case 2:
//            switch row {
//            case 1:
//                print("Licenses")
//            default:
//                print("Shouldn't be here")
//            }
//        case 3:
//            switch row {
//            case 1:
//                print("Rate the App")
//            case 2:
//                print("Log Out")
//            default:
//                print("Shouldn't be here")
//            }
//        default:
//            print("Shouldn't be here")
//            
//        }
}
    