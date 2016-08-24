//
//  HAProfilePagerNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



import AsyncDisplayKit


class HAProfilePagerNode: ASPagerNode, ASPagerDataSource {
    
    
    
    let kInsetTitleTop:     CGFloat = 10.0
    let kInsetTitleBottom:  CGFloat = 10.0
    let kInsetTitleSides:   CGFloat = 10.0
    
    
    let numberOfPages: Int
    
    init(numberOfPages number: Int) {
        
        numberOfPages = number
        
        super.init()
        
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
        return numberOfPages
    }
    
    
    
    //
    //    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
    //
    //
    //
    //
    //        let titleNodeStack = ASStackLayoutSpec(direction: .Vertical,
    //                                               spacing: 0,
    //                                               justifyContent: .Center,
    //                                               alignItems: .Center,
    //                                               children: [text, label])
    //
    //        return titleNodeStack
    //        //        let titleInsets = UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides);
    //        //
    //        //        let textWrapper = ASInsetLayoutSpec(insets: titleInsets, child: titleNodeStack)
    //        //        textWrapper.flexGrow = true
    //        
    //        //        return textWrapper
    //    }
}

