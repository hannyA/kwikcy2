//
//  HADoubleLabelButton.swift
//  PopIn
//
//  Created by Hanny Aly on 6/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

//
//  HABasicNodeLayout.swift
//  PopIn
//
//  Created by Hanny Aly on 6/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


// A button with two titles, main title and subtitle
class HADoubleLabelButton: ASButtonNode {
    
    
    let kInsetTitleTop:     CGFloat = 10.0
    let kInsetTitleBottom:  CGFloat = 10.0
    let kInsetTitleSides:   CGFloat = 10.0
    
    
    var topLabel:  ASTextNode
    var bottomLabel: ASTextNode
    
    
  

        
    init(withTitle textTitle: String, andLabel labelTitle: String) {
        
        topLabel = ASTextNode()
        let attrTitle = HAGlobal.titlesAttributedString(textTitle, color: UIColor.blackColor(), textSize: kTextSizeSmall)
        topLabel.attributedString = attrTitle
        
        
        let bottomLabelTitle = HAGlobal.titlesAttributedString(labelTitle,
                                                               color: UIColor.lightGrayColor(),
                                                               textSize: kTextSizeXXS)
        bottomLabel = HAGlobalNode.createLayerBackedTextNodeWithString(bottomLabelTitle)
        super.init()

    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let titleNodeStack = ASStackLayoutSpec(direction: .Vertical,
                                               spacing: 0,
                                               justifyContent: .Center,
                                               alignItems: .Center,
                                               children: [topLabel, bottomLabel])
        
        return titleNodeStack
        //        let titleInsets = UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides);
        //
        //        let textWrapper = ASInsetLayoutSpec(insets: titleInsets, child: titleNodeStack)
        //        textWrapper.flexGrow = true
        
        //        return textWrapper
    }
}

