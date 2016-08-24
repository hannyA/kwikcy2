//
//  HADiscoveryVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class HADiscoveryVC: ASViewController, ASPagerDataSource {
    
    let pageNode: ASPagerNode
//    let peopleButtonNode: ASButtonNode
//    let groupButtonNode: ASButtonNode
//    let eventsButtonNode: ASButtonNode
//    let underbarNode: ASDisplayNode
    
    init() {
        pageNode = ASPagerNode()
        
        super.init(node: pageNode)
        pageNode.setDataSource(self)
        
        self.title = "Discover"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubnode(pageNode)
    }
    
//    override func viewWillLayoutSubviews() {
////         super.viewWillLayoutSubviews()
//        
//        pageNode.frame = view.bounds
//    }
    
    func pagerNode(pagerNode: ASPagerNode!, nodeAtIndex index: Int) -> ASCellNode! {
        
        let discoveryPageNode = HADiscoveryNode()
        
        
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
