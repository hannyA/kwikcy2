//
//  HACameraViewNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

// used in HACameraVC
class HACameraViewNode: ASCellNode {
    
    
    
    var cameraView: ASImageNode
    
    
    override init() {
        
        
        cameraView = ASImageNode()
        cameraView.backgroundColor = UIColor.grayColor()
        super.init()
        
        usesImplicitHierarchyManagement = true
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        cameraView.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.width)
        
        
//        let a = ASStaticLayoutSpec
        let textStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 5,
                                          justifyContent: .SpaceBetween,
                                          alignItems: .Center,
                                          children: [cameraView])
        
        return textStack
    }
}

