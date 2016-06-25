//
//  HASettingCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/22/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


class HASettingCN: ASCellNode {

    let topHeaderInset:CGFloat = 25
    let topCellInset:CGFloat = 10.0

    let leftInset:CGFloat = 15
    let rightInset:CGFloat = 10.0
    let bottomInset:CGFloat = 7
    
    
    
    let leftImageNode: ASImageNode
    let textNode: ASTextNode
    let rightImageNode: ASImageNode

    let isHeader: Bool
    let hasDivider: Bool
   
    let topDivider: ASDisplayNode
    let bottomDivider: ASDisplayNode
    
    
    
    init(withTitle title: String, isHeader header: Bool, hasDivider _divider: Bool) {
        
        isHeader = header
        hasDivider = _divider
        
        leftImageNode = ASImageNode()
        leftImageNode.layerBacked = true

        textNode = ASTextNode()
        textNode.layerBacked = true

        
        if isHeader {
            textNode.attributedString = HAGlobal.titlesAttributedString(title,
                                                                        color: UIColor.lightGrayColor(),
                                                                        textSize: kTextSizeXS)
            
        } else {
        textNode.attributedString = HAGlobal.titlesAttributedString(title,
                                                                    color: UIColor.blackColor(),
                                                                    textSize: kTextSizeXS)
        }
        
        rightImageNode = ASImageNode()
        rightImageNode.layerBacked = true
        rightImageNode.image = UIImage(named: kRightArrowHead)
        
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
        addSubnode(rightImageNode)
        addSubnode(textNode)

        addSubnode(topDivider)
        addSubnode(bottomDivider)
    }
    
    
    
    
    override func layout() {
        super.layout()
        
        if isHeader {
            // Manually layout the divider.
            let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
            let width = calculatedSize.width
            topDivider.frame = CGRectMake(0, 0, width, pixelHeight)
            if hasDivider {
                bottomDivider.frame = CGRectMake(0, calculatedSize.height-1, width, pixelHeight)
            }
        } else  {
            if hasDivider {
                
                // Manually layout the divider.
                let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
                
                let widthParts = calculatedSize.width/10
                let width = widthParts * 8
                //        let leftInset = widthParts*1.5
                topDivider.frame = CGRectMake(leftInset, 0, width, pixelHeight)
            }
        }
    }
    
    
    

    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        
        var contents = [ASLayoutable]()
        
        contents.append(leftImageNode)
        contents.append(textNode)
        
        let topInset: CGFloat
        
        if !isHeader {
            topInset = topCellInset
            contents.append(spacer)
            contents.append(rightImageNode)
        } else {
            topInset = topHeaderInset
        }
        
        let nodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                               spacing: 0,
                                               justifyContent: .Start,
                                               alignItems: .Center,
                                               children: contents)
        

        let insets = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
        
        let textWrapper = ASInsetLayoutSpec(insets: insets, child: nodeStack)
//        textWrapper.flexGrow = true
        
        return textWrapper
    }
    
    


}