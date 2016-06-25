//
//  HACameraNavigation.swift
//  PopIn
//
//  Created by Hanny Aly on 5/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit


class HACameraNavigation: ASDisplayNode {
    
    
    
    //MARK: Constants
    let LibraryTitle = "Library"
    let CameraTitle = "Camera"


    
    let libraryPagerButton: ASButtonNode
    let cameraPagerButton: ASButtonNode

    
    
    
    
    func attributedString(string: String, forState state: UIControlState) -> NSAttributedString {
        
        switch state {
        case UIControlState.Normal:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!])
        case UIControlState.Highlighted:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.redColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!])
            
        case UIControlState.Selected:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.redColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!])
        default:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!])
        }
    }
    

    
    // Initializer
    override init() {
        
        
        
        libraryPagerButton = ASButtonNode()
        libraryPagerButton.flexGrow = true
       
        cameraPagerButton = ASButtonNode()
        cameraPagerButton.flexGrow = true

        super.init()
       
        let lib = attributedString("library", forState: .Normal)
        libraryPagerButton.setAttributedTitle(lib, forState: .Normal)
        let cam = attributedString("camera", forState: .Normal)
        cameraPagerButton.setAttributedTitle(cam, forState: .Normal)
        
        
        
        
        libraryPagerButton.backgroundColor = UIColor.redColor()
        cameraPagerButton.backgroundColor = UIColor.blueColor()
        
        
        usesImplicitHierarchyManagement = true
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let pageButtonsNodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                                     spacing: 0,
                                                     justifyContent: .SpaceAround,
                                                     alignItems: .Start,
                                                     children: [libraryPagerButton, cameraPagerButton])
        
        
        
        return pageButtonsNodeStack
        
    }
    
    
        
}