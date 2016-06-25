//
//  ProfilePagerControlCellNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

protocol ProfilePagerControlCellNodeDelegate {
    func switchToPageWithTag(buttonTag: Int)
//    func buttonCount()
}

class ProfilePagerControlCellNode: ASCellNode {
    
    var delegate: ProfilePagerControlCellNodeDelegate?
    
    
    let kFirstButton = 1
    let kSecondButton = 2
    
    let kInsetTitleTop:     CGFloat = 10.0
    let kInsetTitleBottom:  CGFloat = 10.0
    let kInsetTitleSides:   CGFloat = 10.0
    
    let leftButton:   ASTaggedButton
//    let middleButton: ASTaggedButton
    let rightButton:  ASTaggedButton
    
    var buttonList = [ASTaggedButton]()
    
    override init() {
        
        leftButton    = ASTaggedButton()
//        middleButton  = ASTaggedButton()
        rightButton   = ASTaggedButton()
        
        buttonList.append(leftButton)
//        buttonList.append(middleButton)
        buttonList.append(rightButton)
        
        super.init()
        
        leftButton.tag = 1
//        middleButton.tag = 2
        rightButton.tag = 2
        
        borderWidth = 2.0
        borderColor = UIColor.blackColor().CGColor
        
        
        let leftAttributedTitle = HAGlobal.titlesAttributedString("My Albums", color: UIColor.blackColor(), textSize: kTextSizeRegular)
        
        let rightAttributedTitle = HAGlobal.titlesAttributedString("Notifications", color: UIColor.lightGrayColor(), textSize: kTextSizeRegular)
        
        leftButton.setAttributedTitle(leftAttributedTitle, forState: .Normal)
//        middleButton.setAttributedTitle(middleTitle, forState: .Normal)
        rightButton.setAttributedTitle(rightAttributedTitle, forState: .Normal)
        
        leftButton.addTarget(self, action: #selector(pageButtonPressed), forControlEvents: .TouchUpInside)
//        middleButton.addTarget(self, action: #selector(middleButtonPressed), forControlEvents: .TouchUpInside)
        rightButton.addTarget(self, action: #selector(pageButtonPressed), forControlEvents: .TouchUpInside)
        
        
        
        
        
        addSubnode(leftButton)
        addSubnode(rightButton)
        
    }
    
    func buttonCount() -> Int {
        return buttonList.count
    }
    
    
    func pageButtonPressed(button: ASTaggedButton) {
        
        let leftButtonColor: UIColor
        let rightButtonColor: UIColor
        
        if button.tag == kFirstButton {
            leftButtonColor = UIColor.blackColor()
            rightButtonColor = UIColor.lightGrayColor()
        } else {
            leftButtonColor = UIColor.lightGrayColor()
            rightButtonColor = UIColor.blackColor()
        }
        
        
        let leftAttributedTitle = HAGlobal.titlesAttributedString("My Albums", color: leftButtonColor, textSize: kTextSizeRegular)
        
        let rightAttributedTitle = HAGlobal.titlesAttributedString("Notifications", color: rightButtonColor, textSize: kTextSizeRegular)
        
        leftButton.setAttributedTitle(leftAttributedTitle, forState: .Normal)
        rightButton.setAttributedTitle(rightAttributedTitle, forState: .Normal)
       
        delegate?.switchToPageWithTag(button.tag!)

    }
    
    
//    func leftButtonPressed() {
//        print("leftButtonPressed")
//        
//        delegate?.pageButtonPressed(<#T##button: ASTaggedButton##ASTaggedButton#>)
//    }
//
//    func middleButtonPressed() {
//        print("middleButtonPressed")
//    }
//    
//    
//    
//    
//    func rightButtonPressed() {
//        print("rightButtonPressed")
//    }
    
    
//    override func layoutDidFinish() {
//        super.layoutDidFinish()
//        print("left button size: \(leftButton.frame)")
//        print("middle button size: \(middleButton.frame)")
//        print("right button size: \(rightButton.frame)")
//        
//        
//        
//        print("left button width: \(leftButton.frame.width), height: \(leftButton.frame.height)")
//        print("middle button width: \(middleButton.frame.width), height: \(middleButton.frame.height)")
//        print("right button width: \(rightButton.frame.width), height: \(rightButton.frame.height)")
//    }




    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        leftButton.flexGrow = true
//        middleButton.flexGrow = true
        rightButton.flexGrow = true
        
        let count: CGFloat = CGFloat( buttonCount() )
       
        let preferredSize =  CGSizeMake(constrainedSize.max.width / count , 40)
       
        leftButton.preferredFrameSize = preferredSize
//        middleButton.preferredFrameSize = preferredSize
        rightButton.preferredFrameSize = preferredSize
        
        let staticLeftButtonSpec = ASStaticLayoutSpec(children: [leftButton])
        
//        let staticMiddleButtonSpec = ASStaticLayoutSpec(children: [ middleButton])
        let staticRightButtonSpec = ASStaticLayoutSpec(children: [ rightButton])

        
        
        let titleNodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                               spacing: 0,
                                               justifyContent: .SpaceBetween,
                                               alignItems: .Center,
                                               children: [staticLeftButtonSpec, staticRightButtonSpec])
        
        return titleNodeStack
        //        let titleInsets = UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides);
        //
        //        let textWrapper = ASInsetLayoutSpec(insets: titleInsets, child: titleNodeStack)
        //        textWrapper.flexGrow = true
        
        //        return textWrapper
    }
}
