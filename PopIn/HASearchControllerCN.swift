//
//  HASearchControllerCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/20/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class HASearchControllerCN: ASCellNode {
    
    let searchControllerNode: HASearchControllerNode
    
    
    override init() {
        
        searchControllerNode = HASearchControllerNode()
        
        super.init()
        
        addSubnode(searchControllerNode)
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let preferredSize =  CGSizeMake(constrainedSize.max.width, 50)
        
        searchControllerNode.preferredFrameSize = preferredSize
//        let staticSearchControllerNodeSpec = ASStaticLayoutSpec(children: [searchControllerNode])
    
        return  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 0, 0), child: searchControllerNode)
    }
}

