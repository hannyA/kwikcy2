//
//  AlbumUploadBottomButtonDisplay.swift
//  PopIn
//
//  Created by Hanny Aly on 6/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


class AlbumUploadBottomButtonDisplay : ASDisplayNode {
    
    
    let createNewAlbumButton: ASButtonNode
    let doneButton: RTLButtonNode
    
    
    override init() {
        
        createNewAlbumButton = ASButtonNode()
        doneButton = RTLButtonNode()
        
        super.init()
        
        backgroundColor = UIColor.whiteColor()
        
        
        
        let attributedStringCreate = HAGlobal.titlesAttributedString("Album",
                                                                     color: UIColor.blackColor(),
                                                                     textSize: kTextSizeRegular)
        createNewAlbumButton.setAttributedTitle(attributedStringCreate, forState: .Normal)
        
        createNewAlbumButton.imageNodeIcon(from: .MaterialIcon,
                                           code: "add.circle",
                                           imageSize: CGSizeMake(40, 40),
                                           ofSize: 40,
                                           color: UIColor.blackColor(),
                                           forState: .Normal)
        
        createNewAlbumButton.backgroundColor = UIColor.greenColor()
        
        
        
        
        // Enabled Done button
        
        doneButton.imageNodeIcon(from: .MaterialIcon,
                                 code: "send",
                                 imageSize: CGSizeMake(40, 40),
                                 ofSize: 40,
                                 color: UIColor.blackColor(),
                                 forState: .Normal)
        
        
        let attributedStringDone = HAGlobal.titlesAttributedString("Done",
                                                                   color: UIColor.blackColor(),
                                                                   textSize: kTextSizeRegular)
        doneButton.setAttributedTitle(attributedStringDone,
                                      forState: .Normal)
        
        // Disabled Done button
        
        doneButton.imageNodeIcon(from: .MaterialIcon,
                                 code: "send",
                                 imageSize: CGSizeMake(40, 40),
                                 ofSize: 40,
                                 color: UIColor.lightGrayColor(),
                                 forState: .Disabled)
        
        let disabledAttributedStringDone = HAGlobal.titlesAttributedString("Done",
                                                                   color: UIColor.lightGrayColor(),
                                                                   textSize: kTextSizeRegular)
        doneButton.setAttributedTitle(disabledAttributedStringDone,
                                      forState: .Disabled)
        
        addSubnode(createNewAlbumButton)
        addSubnode(doneButton)
    }
    
    
    override func didLoad() {
        super.didLoad()
        
        disableDoneButton()
    }
    
    
    func enableDoneButton() {
        doneButton.enabled = true
        
        doneButton.backgroundColor = UIColor.redColor()
    }
    
    
    func disableDoneButton() {
        doneButton.enabled = false
        doneButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.3)
    }
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonHeight = constrainedSize.max.height
        
        let preferredSize =  CGSizeMake(constrainedSize.max.width / 2, buttonHeight)
        
        createNewAlbumButton.preferredFrameSize = preferredSize
        doneButton.preferredFrameSize = preferredSize
        
        
        let staticLeftButtonSpec = ASStaticLayoutSpec(children: [createNewAlbumButton])
        let staticRightButtonSpec = ASStaticLayoutSpec(children: [ doneButton])
        
        let buttonStack = ASStackLayoutSpec(direction: .Horizontal,
                                            spacing: 0,
                                            justifyContent: .SpaceBetween,
                                            alignItems: .Center,
                                            children: [staticLeftButtonSpec, staticRightButtonSpec])
        return buttonStack
        
    }
}