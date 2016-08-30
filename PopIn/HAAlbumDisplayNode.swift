//
//  HAAlbumDisplayNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/6/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

protocol HAAlbumDisplayNodeDelegate {
    func closeAlbumVC()
//    func pauseAlbum()

    func showPreviousItem()
    func showNextItem()
}

class HAAlbumDisplayNode: ASDisplayNode {
    
    var delegate: HAAlbumDisplayNodeDelegate?
   
    // Controls
    let showButtonsOutline: Bool
    
    let closeButton: ASButtonNode
    var timeViewNode: ASTextNode

    let previousItemButton: ASButtonNode
    let nextItemButton: ASButtonNode

    
    let imageNode: ASImageNode
    
    let videoNode: ASVideoNode
    
    
    
    init(mediaContent: MediaModel) {
        
        timeViewNode = ASTextNode()
        
        timeViewNode.attributedText = HAGlobal.titlesAttributedString(String(mediaContent.timeLimit), color: UIColor.blackColor(), textSize: kTextSizeRegular)
        timeViewNode.backgroundColor = UIColor.blueColor()
        timeViewNode.layerBacked = true
        
        showButtonsOutline = true
        
        
        
        
        
        imageNode = ASImageNode()
        imageNode.backgroundColor = UIColor.clearColor()

        videoNode = ASVideoNode()
        
        
        if mediaContent.type == .Photo {
            imageNode.image = UIImage(data: mediaContent.mediaData)
        }
        
        
        
        
        
        previousItemButton = ASButtonNode()
        previousItemButton.setTitle("back", withFont: UIFont.boldSystemFontOfSize(20), withColor: UIColor.blackColor(), forState: .Normal)
        previousItemButton.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)

        nextItemButton = ASButtonNode()
        nextItemButton.setTitle("next", withFont: UIFont.boldSystemFontOfSize(20), withColor: UIColor.blackColor(), forState: .Normal)
        nextItemButton.backgroundColor = UIColor(red: 0.0, green: 0, blue: 1.0, alpha: 0.3)

        

        
        
        closeButton = ASButtonNode()
        closeButton.setTitle("Close", withFont: UIFont.boldSystemFontOfSize(20), withColor: UIColor.blackColor(), forState: .Normal)
        closeButton.backgroundColor = UIColor.redColor()
        
        
        startLocation = CGPointZero
        
        super.init()
        
        
        backgroundColor = UIColor.clearColor()
        addSubnode(imageNode)
        addSubnode(videoNode)
        
        addSubnode(previousItemButton)
        addSubnode(nextItemButton)

        addSubnode(closeButton)
        addSubnode(timeViewNode)
        
        
    }
    
    
    override func didLoad() {
        super.didLoad()
        
        
        closeButton.addTarget(self, action: #selector(closeAlbumView), forControlEvents: .TouchUpInside)
        previousItemButton.addTarget(self, action: #selector(showPreviousItem), forControlEvents: .TouchUpInside)
        nextItemButton.addTarget(self, action: #selector(showNextItem), forControlEvents: .TouchUpInside)
        

        
        imageNode.contentMode = .ScaleAspectFill
        
        imageNode.addTarget(self, action: #selector(doNothing), forControlEvents: .TouchUpInside)
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pauseAlbum))
//        tapGestureRecognizer.numberOfTapsRequired = 1
//        imageNode.view.addGestureRecognizer(tapGestureRecognizer)
    
    
        
//        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeButtonPressed))
//        swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Down
//        imageNode.view.addGestureRecognizer(swipeDownGestureRecognizer)

    
        
        // add your pan recognizer to your desired view
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panedView))
        imageNode.view.addGestureRecognizer(panRecognizer)

        
    }
    
    var startLocation: CGPoint
    
    func panedView(sender:UIPanGestureRecognizer){

        if sender.state == .Began {
            startLocation = sender.locationInView(imageNode.view)
        }
        else if sender.state == .Ended {
            let stopLocation = sender.locationInView(imageNode.view);
            let dx = stopLocation.x - startLocation.x;
            let dy = stopLocation.y - startLocation.y;
            let distance = sqrt(dx*dx + dy*dy );
            NSLog("Distance: %f", distance);

            print("dy:\(dy) stopLocation.y:\(stopLocation.y) startLocation.y:\(startLocation.y)")
            if dy > 100 && distance > 100 {
                //do what you want to do
               closeAlbumView()
            }
        }
    }

    
        
    
    func doNothing(){}
    
//    func pauseAlbum() {
//        print("pauseAlbum")
//        delegate?.pauseAlbum()
//    }
    
    
    func closeAlbumView() {
        print("closeButtonPressed")

        delegate?.closeAlbumVC()
    }
    
    func showPreviousItem() {
        print("showPreviousItem")
        delegate?.showPreviousItem()
    }
    func showNextItem() {
        print("HAAlbumDisplayNode showNextItem")

        delegate?.showNextItem()
    }
    
    
    
    
    
    func updateImageNamed(image: String) {
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.imageNode.image = UIImage(named: image)
            
        }, completion: nil)
    }
    
    
    
    func imageRatioFromSize(size: CGSize) -> CGFloat {
        let imageHeight:CGFloat = size.height - 20
        let imageRatio:CGFloat  = imageHeight / size.width
    
        return imageRatio
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let maxWidth:CGFloat = constrainedSize.max.width
        let maxHeight:CGFloat = constrainedSize.max.height
        
        
        let imageRatio: CGFloat = imageRatioFromSize(constrainedSize.max)
        let imagePlace = ASRatioLayoutSpec(ratio: imageRatio, child: imageNode)
        
        imageNode.preferredFrameSize = CGSizeMake(maxWidth, maxHeight)
        let imageNodeStatic = ASStaticLayoutSpec(children: [imageNode])

        
        
        
        let timeViewWidth:CGFloat  = maxWidth / 5
        let timeViewHeight:CGFloat = maxHeight / 9
        timeViewNode.preferredFrameSize = CGSizeMake(timeViewWidth, timeViewHeight)
        
//        timeViewNode.layoutPosition = CGPointMake(100, 100)
        let timeViewNodePosition = ASStaticLayoutSpec(children: [timeViewNode])
        
        
        
//        let timeViewNodeOverImage = ASOverlayLayoutSpec(child: imageNodeStatic, overlay: timeViewNodePosition)
//        timeViewNodeOverImage.flexGrow = true
        
        
        let closeButtonWidth:CGFloat  = maxWidth / 5
        let closeButtonsHeight:CGFloat = maxHeight / 9
        closeButton.preferredFrameSize = CGSizeMake(closeButtonWidth, closeButtonsHeight )
//        closeButton.layoutPosition = CGPointMake(0, 0)
        let closebuttonPosition = ASStaticLayoutSpec(children: [closeButton])
        
//        let closeButtonOverImage = ASOverlayLayoutSpec(child: timeViewNodeOverImage, overlay: closebuttonPosition)
//        closeButtonOverImage.flexGrow = true
        
        
        
        let topSpacer = ASLayoutSpec()
        topSpacer.flexGrow = true

        
        let topControlStack = ASStackLayoutSpec(direction: .Horizontal,
                                             spacing: 0,
                                             justifyContent: .Start,
                                             alignItems: .Start,
                                             children: [closebuttonPosition, topSpacer, timeViewNodePosition])
        
        topControlStack.flexGrow = true
        
        
        
        
        let topOverlayOverImage = ASOverlayLayoutSpec(child: imageNodeStatic, overlay: topControlStack)
        

        
        
        
        let sideControlButtonsWidth  = constrainedSize.max.width/4
        let sideControlButtonsHeight = constrainedSize.max.height - 100
        
        previousItemButton.preferredFrameSize = CGSizeMake(sideControlButtonsWidth, sideControlButtonsHeight)
        nextItemButton.preferredFrameSize = CGSizeMake(sideControlButtonsWidth, sideControlButtonsHeight)

        let previousItemButtonStatic = ASStaticLayoutSpec(children: [previousItemButton])

        let closebuttonPositionStatic = ASStaticLayoutSpec(children: [nextItemButton])

        previousItemButton.flexGrow = true
        nextItemButton.flexGrow = true
       
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        let controlStack = ASStackLayoutSpec(direction: .Horizontal,
                                             spacing: 0,
                                             justifyContent: .Start,
                                             alignItems: .End,
                                             children: [previousItemButtonStatic, spacer, closebuttonPositionStatic])
        controlStack.flexGrow = true
        
        
        
        
        let displayStack = ASOverlayLayoutSpec(child: topOverlayOverImage, overlay: controlStack)
        displayStack.flexGrow = true
        
        return displayStack

        
//        let fullStack1 = ASStackLayoutSpec(direction: .Vertical,
//                                             spacing: 0,
//                                             justifyContent: .Start,
//                                             alignItems: .Start,
//                                             children: [closebuttonPosition, controlStack])
//        fullStack1.flexGrow  = true
        
        
        

        
        
        
        
//        previousItemButton.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
//        nextItemButton.backgroundColor = UIColor(red: 0.0, green: 0, blue: 1.0, alpha: 0.3)
//        
//        let sideControlButtonsWidth  = constrainedSize.max.width/3
//        let sideControlButtonsHeight = constrainedSize.max.height
//        
//        previousItemButton.preferredFrameSize = CGSizeMake(sideControlButtonsWidth, sideControlButtonsHeight)
//        nextItemButton.preferredFrameSize = CGSizeMake(sideControlButtonsWidth, sideControlButtonsHeight)
//        
////        pauseButton.preferredFrameSize = CGSizeMake(sideControlButtonsWidth, sideControlButtonsHeight/5)
//        
//        
//        
//        
//        
//        
//        let spacer = ASLayoutSpec()
//        spacer.flexGrow = true
//        
//        let fullStack = ASStackLayoutSpec(direction: .Horizontal,
//                                       spacing: 0,
//                                       justifyContent: .Center,
//                                       alignItems: .Center,
//                                       children: [imageNode])
//        
//        return fullStack
        
//        return  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(15,15,15,15), child: smaple)
        
        
        

        
        
        
    }
}