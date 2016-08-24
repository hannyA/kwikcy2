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
//    let editableTextNode: ASEditableTextNode
    
    let textField: HATextField

    let hasTopDivider: Bool
    let hasBottomDivider: Bool
    
    let hasfullTopWidthDivider: Bool
    let hasfullBottomWidthDivider: Bool
    
    let topDivider: ASDisplayNode
    let bottomDivider: ASDisplayNode
    
    
    
    init(withLeftImage leftImage: UIImage, text: String, placeHolderText: String,
                       hasTopDivider top: Bool, fullWidth topWidth: Bool,
                       hasBottomDivider bottom: Bool, fullWidth bottomWidth: Bool) {
       
        hasTopDivider = top
        hasBottomDivider = bottom
        
        hasfullTopWidthDivider = topWidth
        hasfullBottomWidthDivider = bottomWidth
        
        
        leftImageNode = ASImageNode()
        leftImageNode.image = leftImage

        textField = HATextField(shouldSetLeftPadding: false)
        
        textField.textField.text = text
        textField.textField.placeholder = placeHolderText
        
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
        addSubnode(textField)
        
        addSubnode(topDivider)
        addSubnode(bottomDivider)
    }
    
    
    override func layout() {
        super.layout()
       
        // Manually layout the divider.
        let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
        
        
        let width = calculatedSize.width * (4.0/5)
        let originX = (calculatedSize.width - width) / 2
        
        let fullWidth = calculatedSize.width
        let fullOriginX: CGFloat = 0

        
        if hasTopDivider {
            if hasfullTopWidthDivider {
                topDivider.frame = CGRectMake(fullOriginX, 0, fullWidth, pixelHeight)
            } else  {
                topDivider.frame = CGRectMake(originX, 0, width, pixelHeight)
            }
        }
        
        if hasBottomDivider {
            if hasfullBottomWidthDivider {
                
                bottomDivider.frame = CGRectMake(fullOriginX, calculatedSize.height-1, fullWidth, pixelHeight)
            } else {
                
                bottomDivider.frame = CGRectMake(originX, calculatedSize.height-1, width, pixelHeight)
            }
        }
    }
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        textField.preferredFrameSize = CGSizeMake(constrainedSize.max.width - 30, 30)
        let staticTextNode = ASStaticLayoutSpec(children: [textField])
        
        let nodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 10,
                                          justifyContent: .Start,
                                          alignItems: .Center,
                                          children: [leftImageNode, staticTextNode])
        
        let insets = UIEdgeInsetsMake(topCellInset, leftInset, bottomInset, rightInset)
        
        let textWrapper = ASInsetLayoutSpec(insets: insets, child: nodeStack)
        
        return textWrapper
    }
    
    
}