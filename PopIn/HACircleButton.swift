//
//  HACircleButton.swift
//  PopIn
//
//  Created by Hanny Aly on 5/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class HACircleButton: ASButtonNode {
    
    
    override init() {
        super.init()

//        view
//        backgroundImageNode
//        imageNode
//        titleNode
    }
    
    override func didLoad() {
        super.didLoad()
        
        titleNode.cornerRadius = 3
        titleNode.borderColor = UIColor.whiteColor().CGColor
        titleNode.borderWidth = 2
        

//        backgroundImageNode.image = UIImage
        
//        imageNode.image = UIImage
        backgroundImageNode.cornerRadius = 3
        backgroundImageNode.borderColor = UIColor.redColor().CGColor
        backgroundImageNode.borderWidth = 15
        
        
        
//        frame = CGRectMake(0, 0, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
//        
//        button.frame = CGRectMake(135.0, 180.0, 40.0, 40.0);//width and height should be same value
//        
//        button.clipsToBounds = YES;
//        
//        button.layer.cornerRadius = 20;//half of the width
//        
//        button.layer.borderColor=[UIColor redColor].CGColor;
//        
//        button.layer.borderWidth=2.0f;
//        
//        [self.view addSubview:button];
        
    }
    
    
    
//    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
////        
////        preferredFrameSize = CGSizeMake(constrainedSize.max.width, constrainedSize.max.height)
////        clipsToBounds = true
////        layer.cornerRadius = constrainedSize.max.width/2
////        layer.borderColor = UIColor.redColor().CGColor
////        layer.borderWidth = 2
//        
//        
//        
//        let diameter = min(frame.size.height, frame.size.width)
//        //        let diameter = min(bounds.size.height, bounds.size.width)
//        view.frame = CGRectMake(0, 0, diameter, diameter)
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 50
//        view.layer.borderColor = UIColor.blueColor().CGColor
//        view.layer.borderWidth = 2
//        
//        
//        let titleNodeStack = ASStackLayoutSpec(direction: .Vertical,
//                                               spacing: 0,
//                                               justifyContent: .Center,
//                                               alignItems: .Center,
//                                               children: [titleNode])
//        
//        
//        //        textWrapper.flexGrow = true
//        
//        return titleNodeStack
//    }
//
}