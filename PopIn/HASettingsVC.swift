//
//  HASettingsVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class HASettingsVC: ASViewController, ASPagerNodeDataSource {

    var pagerNodeOriginY: CGFloat?
    let kPageButtonHeightFraction: CGFloat = 11
    let kPageButtonWidthFraction: CGFloat = 3
    
    
    let peopleButton: UIButton
    let groupButton: UIButton
    let eventsButton: UIButton
    
    let pagerNode: ASPagerNode
    
    let testFollowPage: HAFollowingVC

    
    init() {
        
        testFollowPage = HAFollowingVC()

        
        peopleButton = UIButton(type: .Custom)
        groupButton = UIButton(type: .Custom)
        eventsButton = UIButton(type: .Custom)
        
        pagerNode = ASPagerNode()
        
        
        super.init(node: pagerNode)
        pagerNode.setDataSource(self)

        
        testFollowPage.view.frame = CGRectMake(0, 200, 400, 400)
        
        pagerNode.backgroundColor = UIColor.darkGrayColor()
        
        peopleButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        groupButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        eventsButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        
        peopleButton.setTitleColor(UIColor.yellowColor(), forState: .Highlighted)
        groupButton.setTitleColor(UIColor.yellowColor(), forState: .Highlighted)
        eventsButton.setTitleColor(UIColor.yellowColor(), forState: .Highlighted)
        
        peopleButton.setTitleColor(UIColor.darkGrayColor(), forState: .Selected)
        groupButton.setTitleColor(UIColor.darkGrayColor(), forState: .Selected)
        eventsButton.setTitleColor(UIColor.darkGrayColor(), forState: .Selected)
        
        peopleButton.setTitle("PEOPLE", forState: .Normal)
        groupButton.setTitle("GROUPS", forState: .Normal)
        eventsButton.setTitle("EVENTS", forState: .Normal)
        
        self.title = "Username"

      }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let peoplePosition: CGFloat = 0
        let groupPosition: CGFloat  = 1
        let eventPosition: CGFloat  = 2
        
        let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
        
        let navigationBarHeight:CGFloat = (navigationController?.navigationBar.frame.size.height)!
      
        let totalNavigationBarHeightOffset = navigationBarHeight + statusBarHeight
        
        
        // Setup Buttons Frame
        let buttonHeight: CGFloat = view.bounds.size.height/kPageButtonHeightFraction
        let buttonWidth = view.bounds.size.width/kPageButtonWidthFraction
        
        
        peopleButton.frame = CGRectMake(buttonWidth*peoplePosition,totalNavigationBarHeightOffset,buttonWidth,buttonHeight)
        groupButton.frame  = CGRectMake(buttonWidth*groupPosition, totalNavigationBarHeightOffset, buttonWidth,buttonHeight)
        eventsButton.frame = CGRectMake(buttonWidth*eventPosition, totalNavigationBarHeightOffset, buttonWidth,buttonHeight)
   
        
        pagerNodeOriginY = totalNavigationBarHeightOffset + buttonHeight
//        pagerNode.frame = CGRectMake(0, 300, view.bounds.width, view.bounds.height - 200)

        
        
        
        view.addSubview(peopleButton)
        view.addSubview(groupButton)
        view.addSubview(eventsButton)
        view.addSubnode(pagerNode)
    }
    
    
    override func viewWillLayoutSubviews() {
        pagerNode.frame = CGRectMake(0, 300, view.bounds.width, view.bounds.height - 200)

    }
    
    
    func pagerNode(pagerNode: ASPagerNode!, nodeAtIndex index: Int) -> ASCellNode! {
        
        let boundSize: CGSize = CGSizeMake(view.frame.width, 400)
        
        let discoveryPageNode = HADiscoveryNode()
        
        discoveryPageNode.preferredFrameSize = boundSize
        if index == 0 {
            discoveryPageNode.backgroundColor = UIColor.redColor()
        } else if index == 1 {
            discoveryPageNode.backgroundColor = UIColor.blueColor()
        } else if index == 2 {
            discoveryPageNode.backgroundColor = UIColor.yellowColor()
        }
        return discoveryPageNode
    }
    
    func numberOfPagesInPagerNode(pagerNode: ASPagerNode!) -> Int {
        return 3
    }
}
