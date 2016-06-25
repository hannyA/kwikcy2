//
//  HAPaddedEditableText.swift
//  PopIn
//
//  Created by Hanny Aly on 5/2/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class HAPaddedEditableText: ASEditableTextNode {
    
    enum kInsetType {
        case TitleTop, TitleBottom, TitleSides
    }
    
    
    // Default values
    var kInsetTitleTop:     CGFloat = 20.0
    var kInsetTitleBottom:  CGFloat = 20.0
    var kInsetTitleSides:   CGFloat = 60.0
    
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
    
    
//    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        
//        let titleInsets = UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides);
//        
//        let layout = ASLayoutable
//        let textWrapper = ASInsetLayoutSpec(insets: titleInsets, child: )
//        textWrapper.flexGrow = true
//        
//        return textWrapper
//    }
}