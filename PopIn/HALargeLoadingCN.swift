//
//  HALargeLoadingCN.swift
//  PopIn
//
//  Created by Hanny Aly on 7/12/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class HALargeLoadingCN: ASCellNode {
    
    let activityIndicatorNode: HAActivityIndicatorNode

    override init() {
        activityIndicatorNode = HAActivityIndicatorNode()
        super.init()
        
        addSubnode(activityIndicatorNode)
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let maxWidth = constrainedSize.max.width
        let height:CGFloat = 100
        
        activityIndicatorNode.preferredFrameSize = CGSizeMake(maxWidth, height)
        let staticActivityIndicatorNode = ASStaticLayoutSpec(children: [activityIndicatorNode])
        
        return staticActivityIndicatorNode
        
    }
    
}