//
//  HACameraControls.swift
//  PopIn
//
//  Created by Hanny Aly on 5/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

//Used in HACameraControlsPagerVC
// This is of pager node type, slides with different controls
class HACameraControlPageNode: ASCellNode {
    
 
    
//    override func calculateLayoutThatFits(constrainedSize: ASSizeRange) -> ASLayout {
//        
//        return ASLayout(layoutableObject: self, size: constrainedSize.max)
//    }
//    
//    override func fetchData() {
//        super.fetchData()
//    }
    
    
    
    
    
    let flipButton: ASButtonNode
    let flashButton: ASButtonNode
    let recordButton: ASButtonNode
    
//    let mediaStorage: ASDisplayNode
//
    override init() {
        
        
        let textSize:CGFloat = 20.0

        func attributedString(string: String) -> NSAttributedString {
            return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
        }
        
//        mediaStorage = ASDisplayNode()
//        mediaStorage.image
        flipButton = ASButtonNode()
        flashButton = ASButtonNode()
        recordButton = ASButtonNode()
        
        
        super.init()
        
        preferredFrameSize = CGSizeMake(375, 187)
        
        flipButton.setAttributedTitle(attributedString("Flip"), forState: .Normal)
        flashButton.setAttributedTitle(attributedString("Flash"), forState: .Normal)
        recordButton.setAttributedTitle(attributedString("Record"), forState: .Normal)
        
        flipButton.addTarget(self, action: #selector(flashButtonPressed), forControlEvents: .TouchUpInside)
        flashButton.addTarget(self, action: #selector(flipButtonPressed), forControlEvents: .TouchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonPressed), forControlEvents: .TouchUpInside)
        
        usesImplicitHierarchyManagement = true

    }
    
    func flashButtonPressed() {
     print("flashButtonPressed")
    }
    
    
    func flipButtonPressed() {
        print("flipButtonPressed")
    }
    
    func recordButtonPressed() {
        print("recordButtonPressed")
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let width = constrainedSize.max.width/3
        
        flipButton.preferredFrameSize = CGSize(width: width, height: 50)
        flashButton.preferredFrameSize = CGSize(width: width, height: 50)
        recordButton.preferredFrameSize = CGSize(width: width, height: 50)

        flipButton.flexGrow = true
        flashButton.flexGrow = true
        recordButton.flexGrow = true
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true

        let controlButtonsStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 5,
                                          justifyContent: .End,
                                          alignItems: .Center,
                                          children: [flipButton, spacer, flashButton])
        controlButtonsStack.alignSelf = .Stretch
        
        let recordButtonStack = ASStackLayoutSpec(direction: .Horizontal,
                                                    spacing: 5,
                                                    justifyContent: .Center,
                                                    alignItems: .Stretch,
                                                    children: [recordButton])
        
        
        let fullStack = ASStackLayoutSpec(direction: .Vertical,
                                                  spacing: 5,
                                                  justifyContent: .Center,
                                                  alignItems: .Stretch,
                                                  children: [controlButtonsStack,recordButtonStack ])
        

        
        
        
        return fullStack

    }
    
    
}