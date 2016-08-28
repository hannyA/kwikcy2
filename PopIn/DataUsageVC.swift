//
//  DataUsageVC.swift
//  PopIn
//
//  Created by Hanny Aly on 8/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//
//
//  HAPushNotificationsVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit
import SwiftyUserDefaults
class DataUsageVC: ASViewController, ASTableDelegate, ASTableDataSource {
    
    
    
    let tableNode: ASTableNode
    
    // Get this data from users AWS cloud settings
    
    let data = ["", "Use less Cellular Data", "This will affect your experience on \(AppName). You may not like what you see."]
    
    var useLessData:Bool
    
    
    init() {
        
        useLessData = Defaults[.useLessData]
        
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
        
        title = "Cellular Data Use"
        tableNode.view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        let title = data[indexPath.row]
        
        if indexPath.row == 0 {
            let textNode = HASettingCN(withTitle: title,
                                   isHeader: true,
                                   hasTopDivider: false,
                                   hasBottomDivider: true)
            
            textNode.selectionStyle = .None
            textNode.userInteractionEnabled = false
            return textNode
            
        } else if indexPath.row == 1 {
            
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
            
            
            let textNode = HARadioCN(withTitle: title,
                                     rightImage: useLessData ? selectedImage: unselectedImage,
                                     hasTopDivider: false,
                                     hasBottomDivider: false)
            
            textNode.selectionStyle = .None
            textNode.backgroundColor = UIColor.whiteColor()
            return textNode
        } else {
            
            let footerCN = HAFooterCN(withTitle: title,
                                      hasTopDivider: true,
                                      hasBottomDivider: false)
                
            
            footerCN.selectionStyle = .None
            return footerCN
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("didSelectRowAtIndexPath")
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
        
        switch indexPath.row {
        case 1:
            
            let cellNode = tableNode.view.nodeForRowAtIndexPath(indexPath) as! HARadioCN
            
            self.useLessData = !self.useLessData

            Defaults[.useLessData] = self.useLessData
            
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                
                if self.useLessData {
                    cellNode.resetRightImage(selectedImage, color: UIColor.flatGreenColor())
                } else {
                    cellNode.resetRightImage(unselectedImage, color: UIColor.grayColor())
                }
                
            }, completion: nil)
        default: break
        }
    }
}
    