//
//  HAPaddedButton.swift
//  PopIn
//
//  Created by Hanny Aly on 5/2/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class HAPaddedButton: ASButtonNode {
    
    enum kInsetType {
        case TitleTop, TitleBottom, TitleSides
    }
    
    
    // Default values
    var kInsetTitleTop:     CGFloat = 20.0
    var kInsetTitleBottom:  CGFloat = 20.0
    var kInsetTitleSides:   CGFloat = 0.0
    
    func changeInset(insetType: kInsetType, withPadding padding: CGFloat) {

        switch insetType {
        case .TitleTop:
            kInsetTitleTop = padding
        case .TitleBottom:
            kInsetTitleBottom = padding
        case .TitleSides:
            kInsetTitleSides = padding
        }
    }
    
    
    override init() {
        super.init()
        
    }

    
    init(topBottom: CGFloat, sides: CGFloat) {
        
        kInsetTitleTop    = topBottom
        kInsetTitleBottom = topBottom
        kInsetTitleSides  = sides
        
        super.init()
    }
    
    
    init(top: CGFloat, bottom: CGFloat, sides: CGFloat) {
        
        kInsetTitleTop    = top
        kInsetTitleBottom = bottom
        kInsetTitleSides  = sides
        
        super.init()
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        
        
        let titleNodeStack = ASStackLayoutSpec(direction: .Vertical,
                                                      spacing: 0,
                                                      justifyContent: .Center,
                                                      alignItems: .Center,
                                                      children: [titleNode])
        
        let titleInsets = UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides);
        
        let textWrapper = ASInsetLayoutSpec(insets: titleInsets, child: titleNodeStack)
//        textWrapper.flexGrow = true
        
        return textWrapper
    }
}