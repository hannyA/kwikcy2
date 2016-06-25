//
//  HAContantFormDisplay.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class HAContactFormDisplay: ASDisplayNode {
    
    let headlineNode: ASTextNode
    let messageNode: ASTextNode
    let textNode: ASEditableTextNode
    
    
    init(headline: String, message: String) {
        
        
        let attributedHeadline = HAGlobal.titlesAttributedString(headline, color: UIColor.lightGrayColor(), textSize: kTextSizeXXS)
        
        headlineNode = HAGlobalNode.createLayerBackedTextNodeWithString(attributedHeadline)
     
        
        let attributedMessage = HAGlobal.titlesAttributedString(message,
                                                                color: UIColor.lightGrayColor(),
                                                                textSize: kTextSizeXXS)
        
        messageNode = HAGlobalNode.createLayerBackedTextNodeWithString(attributedMessage)
        
        
        textNode = ASEditableTextNode()
        
        textNode.typingAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
                                     NSFontAttributeName: UIFont(name: kAppMainFont, size: kTextSizeSmall)!]
       
        super.init()
        
        backgroundColor = UIColor.whiteColor()
        addSubnode(headlineNode)
        addSubnode(messageNode)
        addSubnode(textNode)
    }
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
     
        print("layoutSpecThatFits 1")

        let sidesInset:CGFloat = 15
        
        
        let maxWidth = constrainedSize.max.width
        let maxHeight = constrainedSize.max.height
        
        headlineNode.preferredFrameSize = CGSizeMake(maxWidth, 30)
//        let headlineNodeStatic = ASStaticLayoutSpec(children: [headlineNode])
        
        
        messageNode.preferredFrameSize = CGSizeMake(maxWidth, 30)
//        messageNode.alignSelf = .Center
//        let messageNodeStatic = ASStaticLayoutSpec(children: [messageNode])
        
        
        let nodeStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 6,
                                          justifyContent: .Start,
                                          alignItems: .Start,
                                          children: [headlineNode, messageNode ])
        

        textNode.preferredFrameSize = CGSizeMake(maxWidth - sidesInset*2, maxHeight/2 - 60)
        let textNodeStatic = ASStaticLayoutSpec(children: [textNode])
        
        let fullStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 25,
                                          justifyContent: .Start,
                                          alignItems: .Start,
                                          children: [nodeStack, textNodeStatic ])

        
        let titleInsets = UIEdgeInsetsMake(25, sidesInset, 0, sidesInset)

        let fullWrapper = ASInsetLayoutSpec(insets: titleInsets, child: fullStack)

        
        return fullWrapper
    
    }
}

