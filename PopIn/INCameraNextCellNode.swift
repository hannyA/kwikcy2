//
//  INCameraNextCellNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/1/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit



//protocol INCameraNextDisplayDelegate {
//    
//    func retakeCamera()
//}

protocol INCameraNextCellNodeViewControllerDelegate {
    
    func restartCamera()
    func gotoNextViewController()
    func saveImageData()
}


class INCameraNextCellNode: ASCellNode {
    
    let retakeButton: ASButtonNode
    let saveMediaButton: ASButtonNode
    let nextButton: ASButtonNode
    

    // var displayDelegate:INCameraNextDisplayDelegate?
    var viewContollerDelegate: INCameraNextCellNodeViewControllerDelegate?
    
    override init() {
        
        func createWhiteBorderedButtonNodeWithString(string: String) -> ASButtonNode {
            let buttonNode = ASButtonNode()
            buttonNode.setAttributedTitle(HAGlobal.titlesAttributedString(string, color: UIColor.whiteColor(), textSize: kTextSizeRegular), forState: .Normal)
            buttonNode.setAttributedTitle(HAGlobal.titlesAttributedString(string, color: UIColor.lightBlueColor(), textSize: kTextSizeRegular), forState: .Highlighted)
            buttonNode.setAttributedTitle(HAGlobal.titlesAttributedString(string, color: UIColor.lightBlueColor(), textSize: kTextSizeRegular), forState: .Selected)
            
            buttonNode.backgroundColor  = UIColor.clearColor()
            buttonNode.borderColor = UIColor.whiteColor().CGColor
            buttonNode.borderWidth =  1.0
            buttonNode.cornerRadius = 4.0
            return buttonNode
        }
        
        retakeButton = createWhiteBorderedButtonNodeWithString("Retake")
        saveMediaButton = createWhiteBorderedButtonNodeWithString("Save")
        nextButton = createWhiteBorderedButtonNodeWithString("Next")
        

        super.init()
        
        retakeButton.addTarget(self, action: #selector(retakePhoto), forControlEvents: .TouchUpInside)
        saveMediaButton.addTarget(self, action: #selector(saveMedia), forControlEvents: .TouchUpInside)
        nextButton.addTarget(self, action: #selector(gotoNextViewController), forControlEvents: .TouchUpInside)
        
        addSubnode(retakeButton)
        addSubnode(saveMediaButton)
        addSubnode(nextButton)
    }

    
    func retakePhoto() {
        viewContollerDelegate!.restartCamera()
    }
    
    func saveMedia() {
        viewContollerDelegate!.saveImageData()
    }
    
    func gotoNextViewController() {
        viewContollerDelegate!.gotoNextViewController()
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let sidePaddding = constrainedSize.max.width/30
        let ceilPaddding = constrainedSize.max.width/60
        
        retakeButton.contentEdgeInsets    = UIEdgeInsetsMake(ceilPaddding, sidePaddding*2, ceilPaddding, sidePaddding)
        saveMediaButton.contentEdgeInsets = UIEdgeInsetsMake(ceilPaddding, sidePaddding, ceilPaddding, sidePaddding)
        nextButton.contentEdgeInsets      = UIEdgeInsetsMake(ceilPaddding, sidePaddding, ceilPaddding, sidePaddding*2)
        
        let buttonWidth  = constrainedSize.max.width/5
        let buttonHeight = buttonWidth/3
        
        let preferredSize =  CGSizeMake(buttonWidth, buttonHeight)
        
        retakeButton.preferredFrameSize    = preferredSize
        saveMediaButton.preferredFrameSize = preferredSize
        nextButton.preferredFrameSize      = preferredSize
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        let controlStack2 = ASStackLayoutSpec(direction: .Horizontal,
                                             spacing: 8,
                                             justifyContent: .Center,
                                             alignItems: .Center,
                                             children: [retakeButton, saveMediaButton, spacer, nextButton])
        controlStack2.alignSelf = .Stretch

        
        
        let verticalSpacer = ASLayoutSpec()
        verticalSpacer.flexGrow = true
        
        let fullControlStack = ASStackLayoutSpec(direction: .Vertical,
                                                 spacing: 0,
                                                 justifyContent: .SpaceAround,
                                                 alignItems: .Center ,
                                                 children: [verticalSpacer, controlStack2])
        
        let navStack =  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(buttonHeight*3, 0, 0, 0), child: fullControlStack)
        
        navStack.flexShrink = true
        return navStack
        
        
        
        
        
    }
}