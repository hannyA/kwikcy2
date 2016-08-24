//
//  AccountsVC.swift
//  PopIn
//
//  Created by Hanny Aly on 7/9/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class HAAccountsVC: ASViewController, ASTableDelegate, ASTableDataSource {
    
    
    let tableNode: ASTableNode
    var data: [[String]] = [[String]]()
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Accounts"
        
        var rows = [String]()
        rows.append("")
        rows.append("Change Username")
        rows.append("Delete Username")
        data.append(rows)
        
        let useraccountId = 1
        
        if useraccountId == 1 {
            rows = [String]()
            rows.append("")
            
            let userHasMoreThanOneAccount = false
            let accounts = userHasMoreThanOneAccount ? "All Accounts": "Account"
            rows.append("Delete \(accounts)")
            data.append(rows)
        }
        
        
        // Footer
        rows = [String]()
        rows.append("")
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
    
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        let row = indexPath.row
        if row == 0 {
            
            let headerTitle = data[indexPath.section][indexPath.row]
            
            let textNode: HASettingCN
            if indexPath.section == data.count-1 { // Footer
                textNode = HASettingCN(withTitle: headerTitle,
                                       isHeader: true,
                                       hasTopDivider: true,
                                       hasBottomDivider: false)
            } else {
                textNode = HASettingCN(withTitle: headerTitle,
                                       isHeader: true,
                                       hasTopDivider: true,
                                       hasBottomDivider: true)
            }
            textNode.selectionStyle = .None
            textNode.userInteractionEnabled = false
            return textNode
        } else {
            
            
            let rowTitle = data[indexPath.section][indexPath.row]
            let textNode: HASettingCN
            if row == 1 {
                textNode = HASettingCN(withTitle: rowTitle,
                                       isHeader: false,
                                       hasTopDivider: true,
                                       hasBottomDivider: false)
            } else {
                
                textNode = HASettingCN(withTitle: rowTitle,
                                       isHeader: false,
                                       hasTopDivider: true,
                                       hasBottomDivider: false)
            }
            
            
            textNode.backgroundColor = UIColor.whiteColor()
            textNode.selectionStyle = .Gray
            
            
            return textNode
        }
    }
    
    
    
    
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
    //
    
    
}

