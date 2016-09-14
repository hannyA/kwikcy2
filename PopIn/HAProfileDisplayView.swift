//
//  HAProfileDisplayView.swift
//  PopIn
//
//  Created by Hanny Aly on 8/18/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


class HAProfileDisplayView: ASDisplayNode {
    
    
    let profileView: BasicProfileCellNode
    let tableNode: ASTableNode
    
    init(withUserModel model: MeUserModel) {
        
        profileView = BasicProfileCellNode(withProfileModel: model, loggedInUser: true)
        tableNode = ASTableNode(style: .Plain)
        
        super.init()
        
        tableNode.view.backgroundColor = UIColor.blueColor()
        tableNode.backgroundColor = UIColor.redColor()
        
        addSubnode(tableNode)
        addSubnode(profileView)
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let maxWidth = constrainedSize.max.width
        let maxHeight = constrainedSize.max.height
        let profileViewHeight:CGFloat = maxHeight/3
        
        profileView.preferredFrameSize = CGSizeMake(maxWidth, profileViewHeight)
        let staticProfileViewDisplaySpec = ASStaticLayoutSpec(children: [profileView])
        
        tableNode.flexGrow = true
        let tablePreferredSize = CGSizeMake(maxWidth, maxHeight - profileViewHeight)
        
        print("tablePreferredSize width: \(tablePreferredSize.width) height: \(tablePreferredSize.height)")
        tableNode.preferredFrameSize = tablePreferredSize
        let staticTableNodeSpec = ASStaticLayoutSpec(children: [ tableNode])
        
        
        let fullStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 0,
                                          justifyContent: .SpaceBetween,
                                          alignItems: .End,
                                          children: [staticProfileViewDisplaySpec, staticTableNodeSpec])
        return fullStack
    }
}
