//
//  CameraControlsCellNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/29/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


protocol CameraControlsCellNodeDelegate {
    func cameraShotFinished(image: UIImage)
}


class CameraControlsCellNode: ASCellNode {
    
    let shotButton: ASButtonNode
    let flashButton: ASButtonNode
    let flipButton: ASButtonNode
   
    var delegate:CameraControlsCellNodeDelegate?
    
    let gestuerRec: UITapGestureRecognizer?
    
    
    init(withGestureRec gesture: UITapGestureRecognizer) {
        
        gestuerRec = gesture
        
        shotButton = ASButtonNode()
        flashButton = ASButtonNode()
        flipButton = ASButtonNode()
        
        super.init()
        
        shotButton.backgroundColor = UIColor.blackColor()
        flashButton.backgroundColor = UIColor.blackColor()
        flipButton.backgroundColor = UIColor.blackColor()
        
        shotButton.setImage(UIImage(named: "ic_radio_button_checked"), forState: .Normal)
        flashButton.setImage(UIImage(named: "ic_flash_off"), forState: .Normal)
        flipButton.setImage(UIImage(named: "ic_loop"), forState: .Normal)
        
        
        
        
        
//        shotButton.addTarget(self, action: #selector(tookPhoto), forControlEvents: .TouchUpInside)
        shotButton.borderWidth = 2.0
        shotButton.borderColor = UIColor.greenColor().CGColor
        
        
        addSubnode(shotButton)
        addSubnode(flashButton)
        addSubnode(flipButton)
    }
    
    override init() {

        gestuerRec = nil
        shotButton = ASButtonNode()
        flashButton = ASButtonNode()
        flipButton = ASButtonNode()
    
        super.init()
        
        shotButton.backgroundColor = UIColor.blackColor()
        flashButton.backgroundColor = UIColor.blackColor()
        flipButton.backgroundColor = UIColor.blackColor()
        
        shotButton.setImage(UIImage(named: "ic_radio_button_checked"), forState: .Normal)
        flashButton.setImage(UIImage(named: "ic_flash_off"), forState: .Normal)
        flipButton.setImage(UIImage(named: "ic_loop"), forState: .Normal)
        
        shotButton.addTarget(self, action: #selector(tookPhoto), forControlEvents: .TouchUpInside)
    shotButton.borderWidth = 2.0
        shotButton.borderColor = UIColor.yellowColor().CGColor
        
        
        addSubnode(shotButton)
        addSubnode(flashButton)
        addSubnode(flipButton)
    
    }
    
    func tookPhoto(){
        print("took photoofefe")
    }
    
    override func didLoad() {
        super.didLoad()
        
        print("add gesture")
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        tapGestureRecognizer.numberOfTapsRequired = 1
//        
        if let gest = gestuerRec {
        
            shotButton.view.addGestureRecognizer(gest)
        }
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        print("Photo taken")
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
       
        shotButton.flexGrow = true
        flashButton.flexGrow = true
        flipButton.flexGrow = true

        let navigationStack = ASStackLayoutSpec(direction: .Horizontal,
                                                spacing: 100,
                                                justifyContent: .Start,
                                                alignItems: .Start,
                                                children: [flipButton, spacer, flashButton])
        
        navigationStack.flexGrow = true
        navigationStack.alignSelf = .Stretch
        
        
        let verticalSpacer = ASLayoutSpec()
        verticalSpacer.flexGrow = true
        
        let fullStack = ASStackLayoutSpec(direction: .Vertical,
                                                spacing: 30,
                                                justifyContent: .SpaceBetween,
                                                alignItems: .Center,
                                                children: [navigationStack, verticalSpacer, shotButton])
        fullStack.flexGrow = true
        let ceilings:CGFloat = 10.0
        let sides:CGFloat = 15.0
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(ceilings, sides, ceilings, sides), child: fullStack)
        
        

        

        
        
        
//
//        
//        imageViewContainer.preferredFrameSize = CGSizeMake(constrainedSize.max.width, constrainedSize.max.width)
//        
//        
//        
//        let pageButtonsNodeStack = ASStackLayoutSpec(direction: .Horizontal,
//                                                     spacing: 0,
//                                                     justifyContent: .SpaceAround,
//                                                     alignItems: .Center,
//                                                     children: [cameraPagerButton, libraryPagerButton])
        
    }
}