//
//  HAButtonDisableOverlay.swift
//  PopIn
//
//  Created by Hanny Aly on 6/17/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class HAButtonDisableOverlay: ASButtonNode {
    
    var overlay: ASDisplayNode
    
    override init() {
        overlay = ASDisplayNode()
        super.init()
        
        overlay.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        overlay.hidden = true
    }
    
    func disable(disabled:Bool) {
        overlay.hidden = disabled
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let height = constrainedSize.max.height
        let width = constrainedSize.max.width
        
        overlay.preferredFrameSize = CGSizeMake(width, height)
      
        
        let overlayFG = ASStaticLayoutSpec(children: [overlay])
        let overlayView = ASCenterLayoutSpec(centeringOptions: .XY,
                                              sizingOptions: .Default,
                                              child: overlayFG)
        
        let overlayOverButton = ASOverlayLayoutSpec(child: self,
                                                    overlay: overlayView)
        
        
        return overlayOverButton
        
    }
    
    
}
        