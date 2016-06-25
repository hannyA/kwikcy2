//
//  INCameraTopNavCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/11/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


class INCameraTopNavCN: ASDisplayNode {
    
    var leftNavigationButton: ASButtonNode  // Close button
    var middleNavigationButton: ASButtonNode // Title
    var rightNavigationButton: ASButtonNode // Next button

    
    override init() {
        let leftText = "Close"
        let middleText = "Camera"
        let rightText = ""
        
        leftNavigationButton   = INCameraTopNavCN.createButtonWithAllStatesSetWithText(leftText)
        middleNavigationButton = INCameraTopNavCN.createButtonWithAllStatesSetWithText(middleText)
        rightNavigationButton  = INCameraTopNavCN.createButtonWithAllStatesSetWithText(rightText)
        
        
        super.init()
        
        addSubnode(leftNavigationButton)
        addSubnode(middleNavigationButton)
        addSubnode(rightNavigationButton)
    }
    
    
    
    
    
    class func createButtonWithAllStatesSetWithText(text: String) ->ASButtonNode {
        
        let button = ASButtonNode()
//        button.backgroundColor = UIColor.whiteColor()
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
        button.flexGrow = true
        
        
        let normal = HAGlobal.titlesAttributedString("Cancel", color: UIColor.whiteColor(), textSize: kTextSizeRegular)
        
        let highlighted = HAGlobal.titlesAttributedString("Cancel", color: UIColor.darkGrayColor(), textSize: kTextSizeRegular)
        
        button.setAttributedTitle(normal, forState: .Normal)
        button.setAttributedTitle(highlighted, forState: .Highlighted)
        button.setAttributedTitle(highlighted, forState: .Selected)
        return button
    }

}

