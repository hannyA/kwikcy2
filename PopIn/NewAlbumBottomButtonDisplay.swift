//
//  NewAlbumBottomButtonDisplay.swift
//  PopIn
//
//  Created by Hanny Aly on 6/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


class NewAlbumBottomButtonDisplay : ASDisplayNode {
    
    
    let button: ASButtonNode
    
    override init() {
        
        button = ASButtonNode()
        super.init()
        
        backgroundColor = UIColor.blackColor()
        addSubnode(button)
    }
    
    @objc func createNewAlbumWithTitle(title: String, andPeople list: [UserModel]) {
    
        print("not self createNewAlbumWithTitle")
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonHeight = constrainedSize.max.height
        
        let preferredSize = CGSizeMake(constrainedSize.max.width, buttonHeight)
        
        button.preferredFrameSize = preferredSize
        
        return ASStaticLayoutSpec(children: [button])
    }
}