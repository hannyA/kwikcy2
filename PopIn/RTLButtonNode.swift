//
//  RTLButtonNode.swift
//  PopIn
//
//  Created by Hanny Aly on 8/18/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class RTLButtonNode: ASButtonNode {
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return ASStackLayoutSpec(direction: .Horizontal,
                                 spacing: 10,
                                 justifyContent: .Center,
                                 alignItems: .Center,
                                 children: [titleNode, imageNode])
    }
}
