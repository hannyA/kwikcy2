//
//  HAEditableProfileCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


class HAEditableProfileCN: ASCellNode {
    
    let topHeaderInset:CGFloat = 25
    let topCellInset:CGFloat = 10.0
    
    let leftInset:CGFloat = 15
    let rightInset:CGFloat = 10.0
    let bottomInset:CGFloat = 7
    
    
    let leftImageNode: ASImageNode
    let editableTextNode: ASEditableTextNode
    

    let hasDivider: Bool
    
    let topDivider: ASDisplayNode
    let bottomDivider: ASDisplayNode
    
    
    
    init(withTitle title: String, hasDivider _divider: Bool) {
        
        hasDivider = _divider
        
        leftImageNode = ASImageNode()
        
        editableTextNode = ASEditableTextNode()
        
        editableTextNode.typingAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
                                     NSFontAttributeName: UIFont(name: kAppMainFont, size: kTextSizeSmall)!]
        
        editableTextNode.attributedText = HAGlobal.titlesAttributedString(title, color: UIColor.blackColor(), textSize: kTextSizeSmall)
        
        
        // Hairline cell separator
        topDivider = ASDisplayNode()
        topDivider.layerBacked = true
        topDivider.backgroundColor = UIColor.lightGrayColor()
        // Hairline cell separator
        bottomDivider = ASDisplayNode()
        bottomDivider.layerBacked = true
        bottomDivider.backgroundColor = UIColor.lightGrayColor()
        
        
        
        super.init()
        
        addSubnode(leftImageNode)
        addSubnode(editableTextNode)
        
        addSubnode(topDivider)
        addSubnode(bottomDivider)
    }
    
    
    
    
    override func layout() {
        super.layout()
        
        if hasDivider {
            
            // Manually layout the divider.
            let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
            
            let widthParts = calculatedSize.width/10
            let width = widthParts * 8
            //        let leftInset = widthParts*1.5
            topDivider.frame = CGRectMake(leftInset, 0, width, pixelHeight)
        }

    }
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        
        editableTextNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, 30)
        let staticTextNode = ASStaticLayoutSpec(children: [editableTextNode])
        
            
        let nodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 0,
                                          justifyContent: .Start,
                                          alignItems: .Center,
                                          children: [leftImageNode, staticTextNode])
        
        
        let insets = UIEdgeInsetsMake(topCellInset, leftInset, bottomInset, rightInset)
        
        let textWrapper = ASInsetLayoutSpec(insets: insets, child: nodeStack)
        
        return textWrapper
    }
    
    
    
    
}