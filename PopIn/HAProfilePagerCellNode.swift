//
//  HAProfilePagerCellNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


class HAProfilePagerCellNode: ASCellNode, ASPagerDataSource {
    

    let pagerNode: ASPagerNode
    let numberOfPages: Int
    
    
    init(numberOfPages number: Int) {
        
        numberOfPages = number
        pagerNode = ASPagerNode()
        
        super.init()
        
        pagerNode.setDataSource(self)
        addSubnode(pagerNode)
    }
    
    
    
    
    func pagerNode(pagerNode: ASPagerNode!, nodeAtIndex index: Int) -> ASCellNode! {
       
        print("pagerNode:nodeAtIndex")
        
        let boundSize: CGSize = CGSizeMake(pagerNode.bounds.width, 400)
        print("pagerNode:nodeAtIndex width: \(boundSize)")

        
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
        return numberOfPages
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        pagerNode.flexGrow = true
        
        let titleNodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                               spacing: 0,
                                               justifyContent: .Start,
                                               alignItems: .Start,
                                               children: [pagerNode])
        return titleNodeStack
    }
    
    
    override func layout() {
        super.layout()
        pagerNode.frame = CGRectMake(0, 0, 375, 400)
    }
}

