//
//  NewAlbumDisplayView.swift
//  PopIn
//
//  Created by Hanny Aly on 6/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


//protocol NewAlbumDisplayViewDelegate {
//    func createNewAlbum()
//}


class NewAlbumDisplayView: ASDisplayNode {
    
//    var delegate: NewAlbumDisplayViewDelegate?
    
//    let textFieldNode: HATextField
    let tableNode: ASTableNode
    let buttonDisplay: NewAlbumBottomButtonDisplay
  
    override init() {
        
//        textFieldNode = HATextField(shouldSetLeftPadding: true)
        tableNode = ASTableNode(style: .Plain)
        buttonDisplay = NewAlbumBottomButtonDisplay()
        
        super.init()
 
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
        
//        addSubnode(textFieldNode)
        addSubnode(tableNode)
        addSubnode(buttonDisplay)
    }
    
    
    override func didLoad() {
        super.didLoad()
//        buttonDisplay.button.addTarget(self, action: #selector(createNewAlbum), forControlEvents: .TouchUpInside)
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
            buttonDisplay.button.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
            
            let normalAttribTitle = HAGlobal.titlesAttributedString("Create Album",
                                                                    color: UIColor(white: 0.6, alpha: 0.8),
                                                                    textSize: kTextSizeXL)
            buttonDisplay.button.setAttributedTitle(normalAttribTitle, forState: .Normal)
        }
    }
    
    
    
    
    
    /*  ===========================================================================================
        ===========================================================================================
                Bottom Button Design
        ===========================================================================================
        ===========================================================================================
     */
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let maxWidth = constrainedSize.max.width
        let maxHeight = constrainedSize.max.height
        let buttonHeight:CGFloat = maxHeight/15
        
        buttonDisplay.preferredFrameSize = CGSizeMake(maxWidth, buttonHeight)
        let staticButtonsDisplaySpec = ASStaticLayoutSpec(children: [buttonDisplay])
        
        tableNode.flexGrow = true
        let tablePreferredSize = CGSizeMake(maxWidth, maxHeight - buttonHeight)
        tableNode.preferredFrameSize = tablePreferredSize
        let staticTableNodeSpec = ASStaticLayoutSpec(children: [ tableNode])
        
        
        let fullStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 0,
                                          justifyContent: .SpaceBetween,
                                          alignItems: .End,
                                          children: [staticTableNodeSpec, staticButtonsDisplaySpec])
        return fullStack
    }
}
