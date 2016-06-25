//
//  HAPaddedTextNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/16/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit



class HAPaddedTextNode: ASDisplayNode {
        
    let textnode:ASTextNode

    var kInsetTop:CGFloat = 10
    var kInsetRight:CGFloat = 30
    var kInsetBottom:CGFloat = 10
    var kInsetLeft:CGFloat = 30
    
    override init() {
       
        
        textnode = ASTextNode()
        textnode.layerBacked = true
        super.init()
        
        addSubnode(textnode)
    }
    
    init(top:CGFloat, left:CGFloat, bottom:CGFloat, right:CGFloat) {
        
        kInsetTop = top
        kInsetRight = right
        kInsetBottom = bottom
        kInsetLeft = left
        
        textnode = ASTextNode()
//        textnode.layerBacked = true
        super.init()
        
        addSubnode(textnode)

    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
//        let a = ASLayoutSpec()
//        a.setChild(textnode)
        
        let titleNodeStack = ASStackLayoutSpec(direction: .Vertical,
                                               spacing: 0,
                                               justifyContent: .Center,
                                               alignItems: .Center,
                                               children: [textnode])
        
        let titleInsets = UIEdgeInsetsMake(kInsetTop, kInsetLeft, kInsetBottom, kInsetRight)
        
        let textWrapper = ASInsetLayoutSpec(insets: titleInsets, child: titleNodeStack)
        textWrapper.flexGrow = true
        
        return textWrapper
    }

}
