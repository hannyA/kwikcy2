//
//  SimpleMessageCellNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/18/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class SimpleCellNode: ASCellNode {
    
    
    
    let messageNode: ASTextNode
    let messageFontSize:CGFloat = 20.0
    
    init(withMessage message: String) {
        
        let attributedMessage =  NSAttributedString(string: message,
                                                    fontSize: messageFontSize,
                                                    color: UIColor.lightGrayColor(),
                                                    firstWordColor: nil)
        messageNode = SimpleCellNode.createLayerBackedTextNodeWithString(attributedMessage)
        messageNode.flexGrow = true
        super.init()
        
        backgroundColor = UIColor.blueColor()
        addSubnode(messageNode)
    }
    
    
    class func createLayerBackedTextNodeWithString(attributedString: NSAttributedString) -> ASTextNode {
        let textNode = ASTextNode()
        textNode.layerBacked = true
        textNode.attributedString = attributedString
        return textNode
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let mainContentStack = ASStackLayoutSpec(direction: .Vertical,
                                                 spacing: 5,
                                                 justifyContent: .Center,
                                                 alignItems: .Center,
                                                 children: [messageNode])
        mainContentStack.flexGrow = true

        return mainContentStack
    }
    
}