//
//  HASettingCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/22/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


class HASettingCN: ASCellNode {
    
    let leftImageNode: ASImageNode
    let textNode: ASTextNode
    var rightImageNode: ASImageNode

    let isHeader: Bool
    
    var hasTopDivider: Bool = false
    var hasBottomDivider: Bool = false
   
    let topDivider: ASDisplayNode
    let bottomDivider: ASDisplayNode
    
    var hasLeftImage = true
    
    
    
    
    convenience init(withTitle title: String, isHeader header: Bool, hasTopDivider _topDivider: Bool, hasBottomDivider _bottomDivider: Bool)  {
        
        self.init(withLeftImage: nil, title: title, rightImage: nil, isHeader: header, hasTopDivider: _topDivider, hasBottomDivider: _bottomDivider)
    }
    
    convenience init(withTitle title: String, rightImage: UIImage, isHeader header: Bool, hasTopDivider _topDivider: Bool, hasBottomDivider _bottomDivider: Bool)  {
        
        self.init(withLeftImage: nil, title: title, rightImage: rightImage, isHeader: header, hasTopDivider: _topDivider, hasBottomDivider: _bottomDivider)
    }
    
    
    
    init(withLeftImage leftImage: UIImage?, title: String, rightImage: UIImage?, isHeader header: Bool, hasTopDivider _topDivider: Bool, hasBottomDivider _bottomDivider: Bool) {
        
        isHeader         = header
        hasTopDivider    = _topDivider
        hasBottomDivider = _bottomDivider
        
        
        leftImageNode = ASImageNode()
        leftImageNode.image = leftImage // ?? UIImage()
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
        rightImageNode.image = rightImage // ?? UIImage()
//        leftImageNode.layerBacked = true

        // Hairline cell separator
        topDivider = ASDisplayNode()
        topDivider.layerBacked = true
        topDivider.backgroundColor = UIColor.lightGrayColor()
      
        // Hairline cell separator
        bottomDivider = ASDisplayNode()
        bottomDivider.layerBacked = true
        bottomDivider.backgroundColor = UIColor.lightGrayColor()
        
        
        
        super.init()
        
        if let _  = leftImage {
            addSubnode(leftImageNode)
        }
        addSubnode(textNode)

        if let _  = rightImage {
            addSubnode(rightImageNode)
        }
        
        addSubnode(topDivider)
        addSubnode(bottomDivider)
    }
    
    
    
    func resetRightImage(image: UIImage) {
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveLinear, animations: { 
           
            self.rightImageNode.image = image
            
        }, completion: nil)
    }
    
    
    
    
    override func layout() {
        super.layout()
                
        if isHeader {
           
            // Manually layout the divider.
            let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
            let width = calculatedSize.width
            
            if hasTopDivider {
                topDivider.frame = CGRectMake(0, 0, width, pixelHeight)
                
            }
            if hasBottomDivider {
                bottomDivider.frame = CGRectMake(0, calculatedSize.height-1, width, pixelHeight)

            }
           
        } else  {
            if hasTopDivider {
                
                // Manually layout the divider.
                let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
                
                let width = calculatedSize.width * (10.0/11)
                topDivider.frame = CGRectMake(leftInset, 0, width, pixelHeight)
            }
        }
    }
    
    
    
    
    let topHeaderInset  :CGFloat = 25
    let topCellInset    :CGFloat = 10.0
    
    let leftInset       :CGFloat = 15
    let rightInset      :CGFloat = 10.0
    let bottomInset     :CGFloat = 7
    
    

    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        
        var contents = [ASLayoutable]()
        
        if let _ = leftImageNode.image {
            contents.append(leftImageNode)
        }
        contents.append(textNode)
        
        let topInset = !isHeader ? topCellInset : topHeaderInset
        
        if let _ = rightImageNode.image {
            contents.append(spacer)
            contents.append(rightImageNode)
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