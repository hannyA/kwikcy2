//
//  HATitleCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

let kTitleCNHeight:CGFloat = 40


class HATitleCN: ASCellNode {
    
    let textFieldNode: HATextField
    
    override init() {
        textFieldNode = HATextField(shouldSetLeftPadding: true)

        super.init()
        
//        textFieldNode.textField.delegate = self

        addSubnode(textFieldNode)
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let preferredSize =  CGSizeMake(constrainedSize.max.width, kTitleCNHeight)
        
        textFieldNode.preferredFrameSize = preferredSize
        let staticTextNodeSpec = ASStaticLayoutSpec(children: [textFieldNode])
        
        return  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(5, 0, 0, 0), child: staticTextNodeSpec)
    }
    
    
    
    
//    override func layout() {
//        super.layout()
//        
//        // Manually layout the divider.
//        let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
//        
//        let widthParts = calculatedSize.width/5
//        let width = widthParts * 4
//        let halfSide = widthParts/2
//        
//        _divider.frame = CGRectMake(halfSide, 0, width, pixelHeight)
//    }
    

    }