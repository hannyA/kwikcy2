//
//  AlbumUploadDisplayView.swift
//  PopIn
//
//  Created by Hanny Aly on 6/13/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


protocol AlbumUploadDisplayViewDelegate {
    func presentNewAlbumVC()
    func uploadMediaToSelectedAlbums()
}



class AlbumUploadDisplayView: ASDisplayNode {
    
    var delegate: AlbumUploadDisplayViewDelegate?

    let tableNode: ASTableNode
    let buttonsDisplay: AlbumUploadBottomButtonDisplay
    
    override init() {
       
        tableNode = ASTableNode(style: .Plain)
        
        buttonsDisplay = AlbumUploadBottomButtonDisplay()
        
        super.init()
        
        addSubnode(tableNode)
        addSubnode(buttonsDisplay)
    }
    
    
    override func didLoad() {
        super.didLoad()
        
        buttonsDisplay.createNewAlbumButton.addTarget(self,
                                                     action: #selector(presentNewAlbumVC),
                                                     forControlEvents: .TouchUpInside)
        buttonsDisplay.doneButton.addTarget(self,
                                            action: #selector(uploadMediaToSelectedAlbums),
                                            forControlEvents: .TouchUpInside)
    }
    
    
    func uploadMediaToSelectedAlbums() {
        delegate?.uploadMediaToSelectedAlbums()
    }
    
    
    func presentNewAlbumVC() {
        delegate?.presentNewAlbumVC()
    }
    
    /*
        chop chop
        peek a boo, i see you
        out playing
        ain't nothing but a thang
     still rolling
     tree line
     tiger balm on this jungle's nuts
     
     action jackson
     
     script flip
     
     pasty tea bag
     
     f* you, you can't do what i do
     
     hold up man
     keep it on the down low
     
     fulltard
     
     
     
     
    */
    
//    override func layout() {
//        super.layout()
//        var tableBound = bounds
////        tableBound.height -
//        tableNode.frame = bounds
//  }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonHeight = constrainedSize.max.height/8
        
        buttonsDisplay.preferredFrameSize = CGSizeMake(constrainedSize.max.width, buttonHeight)
        let staticButtonsDisplaySpec = ASStaticLayoutSpec(children: [buttonsDisplay])
        
        tableNode.flexGrow = true
        
        let tablePreferredSize = CGSizeMake(constrainedSize.max.width, constrainedSize.max.height - buttonHeight)
        tableNode.preferredFrameSize = tablePreferredSize
        let staticTableNodeSpec = ASStaticLayoutSpec(children: [ tableNode])

        
        let fullStack = ASStackLayoutSpec(direction: .Vertical,
                                               spacing: 0,
                                               justifyContent: .SpaceBetween,
                                               alignItems: .End,
                                               children: [staticTableNodeSpec, staticButtonsDisplaySpec])
        return fullStack
    }
}


