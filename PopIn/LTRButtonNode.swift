//
//  LTRButtonNode.swift
//  PopIn
//
//  Created by Hanny Aly on 8/20/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class LTRButtonNode: ASButtonNode {
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return ASStackLayoutSpec(direction: .Horizontal,
                                 spacing: 5,
                                 justifyContent: .Center,
                                 alignItems: .Center,
                                 children: [imageNode, titleNode])
    }
}
