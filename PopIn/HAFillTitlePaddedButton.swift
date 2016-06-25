//
//  HAFillTitlePaddedButton.swift
//  PopIn
//
//  Created by Hanny Aly on 6/17/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class HAFillTitlePaddedButton: ASButtonNode {
    
    
    
    // Default values
    var kInsetTitleTop:     CGFloat = 20.0
    var kInsetTitleBottom:  CGFloat = 20.0
    var kInsetTitleSides:   CGFloat = 0.0
    
    
    override init() {
        super.init()
        
        titleNode.borderWidth = 1.0
        titleNode.borderColor = UIColor.redColor().CGColor
        contentVerticalAlignment   = .VerticalAlignmentCenter
        contentHorizontalAlignment = .HorizontalAlignmentMiddle
        
        titleNode.highlightStyle = .Dark
        
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let height = constrainedSize.max.height
        let width = constrainedSize.max.width
        
        titleNode.preferredFrameSize = CGSizeMake(width, height)
        titleNode.flexGrow = true
        titleNode.alignSelf = .Center

        //        ASCenterLayoutSpec *centerSoldOutLabel = [ASCenterLayoutSpec
//            centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
//            sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY
//            child:self.soldOutLabelFlat];
        

        
        
        
//        let staticTitleNode = ASStaticLayoutSpec(children: [titleNode])
//        
//        return staticTitleNode
        
        let titleNodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                               spacing: 0,
                                               justifyContent: .Center,
                                               alignItems: .Center,
                                               children: [titleNode])
        titleNodeStack.flexGrow = true
        titleNodeStack.alignSelf = .Center
        return titleNodeStack
//        let titleInsets = UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides);
//        
//        let textWrapper = ASInsetLayoutSpec(insets: titleInsets, child: titleNodeStack)
//        //        textWrapper.flexGrow = true
//        
//        return textWrapper
    }
}