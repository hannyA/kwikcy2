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
    let topDivider: ASDisplayNode
    let bottomDivider: ASDisplayNode
    
    
    var hasTopDivider   : Bool = false
    var hasBottomDivider: Bool = false
    
    
    
    convenience init(withLeftTitle leftTitle: String, verificationString: NSAttributedString, rightTitle: String, hasTopDivider _topDivider: Bool, hasBottomDivider _bottomDivider: Bool)  {
        
        let beginText = NSAttributedString(string: leftTitle,
                                           fontSize: kTextSizeXS,
                                           color: UIColor.lightGrayColor(),
                                           firstWordColor: nil)
        let endText = NSAttributedString(string: rightTitle,
                                         fontSize: kTextSizeXS,
                                         color: UIColor.lightGrayColor(),
                                         firstWordColor: nil)
        
        let verificationText = NSMutableAttributedString(attributedString: beginText)
        verificationText.appendAttributedString(verificationString)
        verificationText.appendAttributedString(endText)
        
        
        self.init(withAttributedTitle: verificationText, hasTopDivider: _topDivider, hasBottomDivider: _bottomDivider)
    }
    
    
    
    convenience init(withTitle title: String, hasTopDivider _topDivider: Bool, hasBottomDivider _bottomDivider: Bool)  {
        
        let attributedTitle = HAGlobal.titlesAttributedString(title,
                                                              color: UIColor.lightGrayColor(),
                                                              textSize: kTextSizeXS)
        
        self.init(withAttributedTitle: attributedTitle, hasTopDivider: _topDivider, hasBottomDivider: _bottomDivider)
    }
    
    
    init(withAttributedTitle attributedTitle: NSAttributedString, hasTopDivider _topDivider: Bool, hasBottomDivider _bottomDivider: Bool)  {
        
        hasTopDivider    = _topDivider
        hasBottomDivider = _bottomDivider
        
        
        
        textNode = ASTextNode()
        textNode.attributedString = attributedTitle
        textNode.layerBacked = true

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
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(7, 15, 7, 10),
                                            child: textNode)
    }
}