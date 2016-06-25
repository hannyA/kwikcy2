//
//  FakeDisplay.swift
//  PopIn
//
//  Created by Hanny Aly on 6/20/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class FakeDisplay: ASDisplayNode {
    
    let textFieldNode: HATextField
    let collectionNode: HorizontalScrollCell

    let searchControllerNode: HASearchControllerNode
    let tableNode: ASTableNode
    let buttonDisplay: NewAlbumBottomButtonDisplay
    
    
    
    override init() {
        
        textFieldNode = HATextField(shouldSetLeftPadding: true)
        
        collectionNode = HorizontalScrollCell(initWithElementSize: CGSizeMake(100, 100))
        
        searchControllerNode = HASearchControllerNode()
        tableNode = ASTableNode(style: .Plain)
        buttonDisplay = NewAlbumBottomButtonDisplay()
        
        super.init()
        
        tableNode.view.tableHeaderView = searchControllerNode.searchController.searchBar
        
        buttonDisplay.backgroundColor = UIColor.whiteColor()
        
        buttonDisplay.button.backgroundColor = UIColor(white: 0.0, alpha: 1)
        
        let normalAttribTitle = HAGlobal.titlesAttributedString("Create Album",
                                                                color: UIColor.whiteColor(),
                                                                textSize: kTextSizeXL)
        buttonDisplay.button.setAttributedTitle(normalAttribTitle, forState: .Normal)
        
        let selectedAttribTitle = HAGlobal.titlesAttributedString("Create Album",
                                                                  color: UIColor.darkGrayColor(),
                                                                  textSize: kTextSizeXL)
        buttonDisplay.button.setAttributedTitle(selectedAttribTitle, forState: .Highlighted)
        
        
        enableBottomButton(false)

        addSubnode(textFieldNode)
        addSubnode(collectionNode)
        addSubnode(searchControllerNode)
        addSubnode(tableNode)
        addSubnode(buttonDisplay)
   }
    
    
    func enableBottomButton(enabled:Bool) {
        
        buttonDisplay.button.enabled = enabled
        
        if enabled {
            buttonDisplay.button.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
            
            
            let normalAttribTitle = HAGlobal.titlesAttributedString("Create Album",
                                                                    color: UIColor.whiteColor(),
                                                                    textSize: kTextSizeXL)
            buttonDisplay.button.setAttributedTitle(normalAttribTitle, forState: .Normal)
            
        } else  {
            buttonDisplay.button.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
            
            let normalAttribTitle = HAGlobal.titlesAttributedString("Create Album",
                                                                    color: UIColor(white: 0.6, alpha: 0.8),
                                                                    textSize: kTextSizeXL)
            buttonDisplay.button.setAttributedTitle(normalAttribTitle, forState: .Normal)
        }
    }
    
    
    
    
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let maxWidth = constrainedSize.max.width
        let maxHeight = constrainedSize.max.height
        let textFieldHeight:CGFloat = 50
        let collectionNodeHeight:CGFloat = 100

        let searchBarHeight:CGFloat = 50
        let bottonButtonHeight = constrainedSize.max.height/10

        let tableHeightMax = maxHeight - textFieldHeight - bottonButtonHeight - searchBarHeight
        
        let preferredSize = CGSizeMake(maxWidth, textFieldHeight)
        textFieldNode.preferredFrameSize = preferredSize
        let staticTextNodeSpec = ASStaticLayoutSpec(children: [textFieldNode])
//        let textNodeWrapper = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(5, 0, 5, 0), child: staticTextNodeSpec)
        
        collectionNode.flexGrow = true
        collectionNode.preferredFrameSize = CGSizeMake(maxWidth, collectionNodeHeight)
        
        
        searchControllerNode.flexGrow = true
        searchControllerNode.preferredFrameSize = CGSizeMake(maxWidth, searchBarHeight)

        tableNode.flexGrow = true
        let tablePreferredSize = CGSizeMake(maxWidth, tableHeightMax)
        tableNode.preferredFrameSize = tablePreferredSize
//        let staticTableNodeSpec = ASStaticLayoutSpec(children: [ tableNode])
        
        buttonDisplay.preferredFrameSize = CGSizeMake(constrainedSize.max.width, bottonButtonHeight)
        let staticButtonsDisplaySpec = ASStaticLayoutSpec(children: [buttonDisplay])
        
        
        let fullStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 0,
                                          justifyContent: .Start ,
                                          alignItems: .End,
                                          children: [staticTextNodeSpec, searchControllerNode, tableNode, staticButtonsDisplaySpec])
        return fullStack
    }

}
