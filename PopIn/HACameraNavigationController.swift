//
//  HACameraNavigationController.swift
//  PopIn
//
//  Created by Hanny Aly on 5/27/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


protocol HACameraNavigationControllerDelegate {
    func didCancelCamera()
    func moveToNextVC()
}

class HACameraNavigationController: ASDisplayNode {
    
    var delegate: HACameraNavigationControllerDelegate?
    
    
    var leftButton: ASButtonNode
    var middleButton: ASButtonNode
    var rightButton: ASButtonNode
    
    
    
    init(leftText: String, middleText: String, rightText: String) {
        
        let textSize:CGFloat = 16.0
        
        
        func attributedString(string: String) -> NSAttributedString {
            
            return NSAttributedString(string: string, attributes:
                [NSForegroundColorAttributeName: UIColor.blackColor(),
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
        }
        
        leftButton = ASButtonNode()
        leftButton.setAttributedTitle(attributedString(leftText), forState: .Normal)
        
        middleButton = ASButtonNode()
        middleButton.setAttributedTitle(attributedString(middleText), forState: .Normal)
        
        
        rightButton = ASButtonNode()
        rightButton.setAttributedTitle(attributedString(rightText), forState: .Normal)
        
        
        
        
        
        super.init()
        backgroundColor = UIColor.grayColor()
        
        leftButton.addTarget(self, action: #selector(dismissCamera), forControlEvents: .TouchUpInside)
        rightButton.addTarget(self, action: #selector(moveToNextViewController), forControlEvents: .TouchUpInside)
        
        
        usesImplicitHierarchyManagement = true
    }
    
    func dismissCamera() {
        delegate?.didCancelCamera()
    }
    
    
    func moveToNextViewController() {
        delegate?.moveToNextVC()
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let textStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 5,
                                          justifyContent: .SpaceBetween,
                                          alignItems: .Center,
                                          children: [leftButton, middleButton, rightButton])
        let ceilings:CGFloat = 10.0
        let sides:CGFloat = 15.0
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(ceilings, sides, ceilings, sides), child: textStack)
    }
}

