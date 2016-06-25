//
//  HACameraPagerControllerNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


// used in HACameraVC
class HACameraPagerControllerNode: ASCellNode {
    
    
    
    let LibraryTitle = "Library"
    let CameraTitle = "Camera"
    
    
    
    let libraryPagerButton: ASButtonNode
    let cameraPagerButton: ASButtonNode
    
    
    
    
    let messageFontSize:CGFloat = 14.0
    
    
    override init() {
        

        libraryPagerButton = ASButtonNode()
        libraryPagerButton.flexGrow = true
        
        cameraPagerButton = ASButtonNode()
        cameraPagerButton.flexGrow = true
        
        
        super.init()
    
        let lib = attributedString("Library", forState: .Normal)
        libraryPagerButton.setAttributedTitle(lib, forState: .Normal)
        let cam = attributedString("Camera", forState: .Normal)
        cameraPagerButton.setAttributedTitle(cam, forState: .Normal)
        
        
        libraryPagerButton.backgroundColor = UIColor.redColor()
        cameraPagerButton.backgroundColor = UIColor.blueColor()
        
        
        usesImplicitHierarchyManagement = true

    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let textStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 5,
                                          justifyContent: .SpaceBetween,
                                          alignItems: .Center,
                                          children: [libraryPagerButton, cameraPagerButton])
        
        return textStack
    }
    
    func attributedString(string: String, forState state: UIControlState) -> NSAttributedString {
        
        switch state {
        case UIControlState.Normal:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!])
        case UIControlState.Highlighted:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.redColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!])
            
        case UIControlState.Selected:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.redColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!])
        default:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!])
        }
    }
    
}

