//
//  HASearchTextField.swift
//  PopIn
//
//  Created by Hanny Aly on 6/15/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit



class HASearchTextField: ASCellNode {
    
    let topDivider: ASDisplayNode

    let toTextNode: ASTextNode
    let textFieldNode: HATextField
    let searchNode: ASButtonNode

    let bottomDivider: ASDisplayNode

    override init() {
        
        toTextNode = ASTextNode()
        textFieldNode = HATextField(shouldSetLeftPadding: false)
        searchNode = ASButtonNode()

        
//        toTextNode.borderColor = UIColor.redColor().CGColor
//        textFieldNode.borderColor = UIColor.greenColor().CGColor
//
//        toTextNode.borderWidth = 1.0
//        textFieldNode.borderWidth = 1.0
        
        topDivider = ASDisplayNode()
        topDivider.backgroundColor = UIColor.lightGrayColor()
        bottomDivider = ASDisplayNode()
        bottomDivider.backgroundColor = UIColor.lightGrayColor()
        
        
        
        
        super.init()
        
        textFieldNode.textField.placeholder = "Search..."
        toTextNode.attributedString = HAGlobal.titlesAttributedString("🔍", color: UIColor.redColor(), textSize: kTextSizeXS)
        
        let searchTitle = HAGlobal.titlesAttributedString("Find Others", color: UIColor.redColor(), textSize: kTextSizeXS)
        searchNode.setAttributedTitle(searchTitle, forState: .Normal)
        
        addSubnode(topDivider)
        addSubnode(bottomDivider)

        addSubnode(toTextNode)
        addSubnode(textFieldNode)
        addSubnode(searchNode)

    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let mainScreenHeight = UIScreen.mainScreen().bounds.height
       
        let seventhsWidth:  CGFloat = constrainedSize.max.width/7
        let maxHeight:      CGFloat = mainScreenHeight/15
        
        let toButtonWidth:     CGFloat = seventhsWidth
        let searchFieldWidth:  CGFloat = seventhsWidth*4
        let searchButtonWidth: CGFloat = seventhsWidth*2
        
        
        
        let preferredToButtonSize = CGSizeMake(toButtonWidth, maxHeight)
        toTextNode.preferredFrameSize = preferredToButtonSize
        
        
        let preferredSize =  CGSizeMake(searchFieldWidth, maxHeight)
        textFieldNode.preferredFrameSize = preferredSize
        let staticTextNodeSpec = ASStaticLayoutSpec(children: [textFieldNode])
        
        let preferredSearchSize = CGSizeMake(searchButtonWidth, maxHeight)
        searchNode.preferredFrameSize = preferredSearchSize
        
        
        let fullStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 5,
                                          justifyContent: .Start,
                                          alignItems: .Center,
                                          children: [ toTextNode, staticTextNodeSpec, searchNode])
        
//        let a = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        return  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(1, 15, 1, 0), child: fullStack)
        
    }
    


    
    override func layout() {
        super.layout()

        // Manually layout the divider.
        let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];

        let widthParts = calculatedSize.width
//        let width = widthParts * 4
//        let halfSide = widthParts/2

        print("calculatedSize.height = \(calculatedSize.height)")
        
        bottomDivider.frame = CGRectMake(0, calculatedSize.height-1, widthParts, pixelHeight)
        topDivider.frame = CGRectMake(0, 0, widthParts, pixelHeight)
    }

}


