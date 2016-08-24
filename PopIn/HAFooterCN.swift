//
//  HAFooterCN.swift
//  PopIn
//
//  Created by Hanny Aly on 8/23/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



import AsyncDisplayKit

class HAFooterCN: ASCellNode {
    
    let textNode: ASTextNode
    
    var hasTopDivider   : Bool = false
    var hasBottomDivider: Bool = false
    
    let topDivider: ASDisplayNode
    let bottomDivider: ASDisplayNode
    
    
    init(withTitle title: String, hasTopDivider _topDivider: Bool, hasBottomDivider _bottomDivider: Bool)  {
        
        hasTopDivider    = _topDivider
        hasBottomDivider = _bottomDivider
        
        
        
        textNode = ASTextNode()
        textNode.layerBacked = true
        
        
        textNode.attributedString = HAGlobal.titlesAttributedString(title,
                                                                    color: UIColor.lightGrayColor(),
                                                                    textSize: kTextSizeXS)
        
        // Hairline cell separator
        topDivider = ASDisplayNode()
        topDivider.layerBacked = true
        topDivider.backgroundColor = UIColor.lightGrayColor()
        
        // Hairline cell separator
        bottomDivider = ASDisplayNode()
        bottomDivider.layerBacked = true
        bottomDivider.backgroundColor = UIColor.lightGrayColor()
        
        
        
        super.init()
        
        addSubnode(textNode)
        addSubnode(topDivider)
        addSubnode(bottomDivider)
    }
    
    
    override func layout() {
        super.layout()
        
        // Manually layout the divider.
        let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
        let width = calculatedSize.width
        
        if hasTopDivider {
            topDivider.frame = CGRectMake(0, 0, width, pixelHeight)
            
        }
        if hasBottomDivider {
            bottomDivider.frame = CGRectMake(0, calculatedSize.height-1, width, pixelHeight)
            
        }
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        
        var contents = [ASLayoutable]()
        
        contents.append(textNode)
        
        let topInset        :CGFloat = 7
        let leftInset       :CGFloat = 15
        let rightInset      :CGFloat = 10.0
        let bottomInset     :CGFloat = 7
        
        let nodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 0,
                                          justifyContent: .Start,
                                          alignItems: .Center,
                                          children: contents)
        
        
        let insets = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
        
        let textWrapper = ASInsetLayoutSpec(insets: insets, child: nodeStack)
        
        return textWrapper
    }
    
    
    
    
}