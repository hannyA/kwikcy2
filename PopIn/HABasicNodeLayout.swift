//
//  HABasicNodeLayout.swift
//  PopIn
//
//  Created by Hanny Aly on 6/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


class HABasicNodeLayout: ASButtonNode {
    
    
    let kInsetTitleTop:     CGFloat = 10.0
    let kInsetTitleBottom:  CGFloat = 10.0
    let kInsetTitleSides:   CGFloat = 10.0
    
    let text:  ASTextNode
    let label: ASTextNode
    
    
    init(withTitle textTitle: String, andLabel labelTitle: String) {
        
        text = ASTextNode()
        label = ASTextNode()
        
        super.init()
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        
        
        let titleNodeStack = ASStackLayoutSpec(direction: .Vertical,
                                               spacing: 0,
                                               justifyContent: .Center,
                                               alignItems: .Center,
                                               children: [text, label])
        
        let titleInsets = UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides)

        let textWrapper = ASInsetLayoutSpec(insets: titleInsets, child: titleNodeStack)
        textWrapper.flexGrow = true
        
        return textWrapper
    }
    
    
    
//    For static sized button
//    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        
//
//        
//        leftButton.flexGrow = true
//        //        middleButton.flexGrow = true
//        rightButton.flexGrow = true
//        
//        let count: CGFloat = CGFloat( buttonCount() )
//        
//        let preferredSize =  CGSizeMake(constrainedSize.max.width / count , 40)
//        
//        leftButton.preferredFrameSize = preferredSize
//        //        middleButton.preferredFrameSize = preferredSize
//        rightButton.preferredFrameSize = preferredSize
//        
//        let staticLeftButtonSpec = ASStaticLayoutSpec(children: [leftButton])
//        
//        //        let staticMiddleButtonSpec = ASStaticLayoutSpec(children: [ middleButton])
//        let staticRightButtonSpec = ASStaticLayoutSpec(children: [ rightButton])
//        
//        
//        
//        let titleNodeStack = ASStackLayoutSpec(direction: .Horizontal,
//                                               spacing: 0,
//                                               justifyContent: .SpaceBetween,
//                                               alignItems: .Center,
//                                               children: [staticLeftButtonSpec, staticRightButtonSpec])
//        
//        return titleNodeStack
//    }
    

}

