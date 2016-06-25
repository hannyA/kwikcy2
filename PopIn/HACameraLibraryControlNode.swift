//
//  HACameraLibraryControlNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit



//Used in HACameraControlsPagerVC
// This is of pager node type, slides with different controls
class HACameraLibraryControlNode: ASCellNode {
    
    
    
    
    
    override func calculateLayoutThatFits(constrainedSize: ASSizeRange) -> ASLayout {
        
        return ASLayout(layoutableObject: self, size: constrainedSize.max)
    }
    
    override func fetchData() {
        super.fetchData()
    }
    
    
//    
//    let flipButton: ASButtonNode
//    let flashButton: ASButtonNode
//    let recordButton: ASButtonNode
//    
//    //    let mediaStorage: ASDisplayNode
//    
//    override init() {
//        
//        let textSize:CGFloat = 20.0
//        
//        func attributedString(string: String) -> NSAttributedString {
//            return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
//                NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
//        }
//        
//        //        mediaStorage = ASDisplayNode()
//        //        mediaStorage.image
//        flipButton = ASButtonNode()
//        flashButton = ASButtonNode()
//        recordButton = ASButtonNode()
//        
//        super.init()
//        
//        flipButton.setAttributedTitle(attributedString("libar"), forState: .Normal)
//        flashButton.setAttributedTitle(attributedString("libarFlash"), forState: .Normal)
//        recordButton.setAttributedTitle(attributedString("libarRecord"), forState: .Normal)
//        
//        flipButton.addTarget(self, action: #selector(flashButtonPressed), forControlEvents: .TouchUpInside)
//        flashButton.addTarget(self, action: #selector(flipButtonPressed), forControlEvents: .TouchUpInside)
//        recordButton.addTarget(self, action: #selector(recordButtonPressed), forControlEvents: .TouchUpInside)
//        
//        usesImplicitHierarchyManagement = true
//        
//    }
//    
//    
//    
//    func flashButtonPressed() {
//        print("flashButtonPressed")
//    }
//    
//    
//    func flipButtonPressed() {
//        print("flipButtonPressed")
//    }
//    
//    func recordButtonPressed() {
//        print("recordButtonPressed")
//    }
//    
//    
//    
//    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        
//        
//        let width = constrainedSize.max.width/3
//        
//        let spacer = ASLayoutSpec()
//        spacer.flexGrow = true
//        
//        flipButton.preferredFrameSize = CGSize(width: width, height: 50)
//        flashButton.preferredFrameSize = CGSize(width: width, height: 50)
//        recordButton.preferredFrameSize = CGSize(width: width, height: 50)
//        
//        let textStack = ASStackLayoutSpec(direction: .Horizontal,
//                                          spacing: 5,
//                                          justifyContent: .SpaceBetween,
//                                          alignItems: .Center,
//                                          children: [flipButton, spacer, flashButton, recordButton])
//        
//        return textStack
//        
//    }
//    
    
}