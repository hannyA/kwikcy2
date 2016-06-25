//
//  HADiscoveryNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/6/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class HADiscoveryNode: ASCellNode {
    
    
    override func calculateLayoutThatFits(constrainedSize: ASSizeRange) -> ASLayout {
        
        return ASLayout(layoutableObject: self, size: constrainedSize.max)
    }
    
    override func fetchData() {
        super.fetchData()
    }

}