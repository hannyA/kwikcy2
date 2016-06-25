//
//  AlbumUploadBottomButtonDisplay.swift
//  PopIn
//
//  Created by Hanny Aly on 6/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


class AlbumUploadBottomButtonDisplay : ASDisplayNode {
    
    
    let bottomButton1: ASButtonNode
    let bottomButton2: ASButtonNode
    
    
    override init() {
        
        bottomButton1 = ASButtonNode()
        bottomButton2 = ASButtonNode()
        
        super.init()
        
        backgroundColor = UIColor.whiteColor()
        
        let attributedStringCreate = HAGlobal.titlesAttributedString("+ Album", color: UIColor.blackColor(), textSize: kTextSizeRegular)
        
        let attributedStringDone = HAGlobal.titlesAttributedString("Done >", color: UIColor.lightGrayColor(), textSize: kTextSizeRegular)
        
        bottomButton1.setAttributedTitle(attributedStringCreate, forState: .Normal)
        bottomButton1.backgroundColor = UIColor.greenColor()
        
        bottomButton2.setAttributedTitle(attributedStringDone, forState: .Normal)
        bottomButton2.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.3)
        
        addSubnode(bottomButton1)
        addSubnode(bottomButton2)
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonHeight = constrainedSize.max.height
        
        let preferredSize =  CGSizeMake(constrainedSize.max.width / 2, buttonHeight)
        
        bottomButton1.preferredFrameSize = preferredSize
        bottomButton2.preferredFrameSize = preferredSize
        
        
        let staticLeftButtonSpec = ASStaticLayoutSpec(children: [bottomButton1])
        let staticRightButtonSpec = ASStaticLayoutSpec(children: [ bottomButton2])
        
        let buttonStack = ASStackLayoutSpec(direction: .Horizontal,
                                            spacing: 0,
                                            justifyContent: .SpaceBetween,
                                            alignItems: .Center,
                                            children: [staticLeftButtonSpec, staticRightButtonSpec])
        return buttonStack
        
    }
}