//
//  HACameraPagerVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class HACameraPagerVC: ASViewController, ASPagerNodeDataSource  {
    
    let pagerNode: ASPagerNode
    
    
    init() {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.minimumInteritemSpacing  = 1
        _flowLayout.minimumLineSpacing       = 1
        _flowLayout.scrollDirection = .Horizontal
        
//        let a = ASPagerFlowLayout()
//        a.scrollDirection =
        
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
        view.backgroundColor = UIColor.greenColor()
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
        return 2
    }
    
    
    
}
