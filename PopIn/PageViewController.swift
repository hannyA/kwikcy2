//
//  PageViewController.swift
//  PopIn
//
//  Created by Hanny Aly on 5/10/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PageViewController: ASViewController, ASPagerDataSource  {
    
    let pagerNode: ASPagerNode
    
    
    init() {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.minimumInteritemSpacing  = 1
        _flowLayout.minimumLineSpacing       = 1
        _flowLayout.scrollDirection = .Horizontal
        
        pagerNode = ASPagerNode()
        
        super.init(node: pagerNode)
        
        pagerNode.setDataSource(self)
        pagerNode.backgroundColor = UIColor.darkGrayColor()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "item1"
        view.backgroundColor = UIColor.darkGrayColor()
    }
    
    
    
    
    func pagerNode(pagerNode: ASPagerNode!, nodeAtIndex index: Int) -> ASCellNode! {
        
        let boundSize: CGSize = CGSizeMake(pagerNode.bounds.width, 400)
        
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
