//
//  INCameraControlsCellNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/30/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


@objc protocol INCameraControlsCellNodeViewControllerDelegate {
 
    func dismissCamera()
    func photoWillBeTaken()
    func videoStarted()
    func videoStopped()
}


protocol INCameraControlsCellNodeDisplayDelegate {
    
    func cameraHasFlipCamera() -> Bool
    func cameraHasFlash() -> Bool
    func shouldSetupFlash() -> Bool
    func switchFlashConfig() -> AVCaptureFlashMode?
    func flipCamera() -> (flipped: Bool, position: AVCaptureDevicePosition?)
}




class INCameraControlsCellNode: ASCellNode {
    
    let closeButton: ASButtonNode
    let captureButton: ASButtonNode
    let flashButton: ASButtonNode
    let flipButton: ASButtonNode
    
    weak var viewControllerDelegate:INCameraControlsCellNodeViewControllerDelegate?
    var displayDelegate:INCameraControlsCellNodeDisplayDelegate?
    
    var videoIsRecording: Bool = false
    var isCameraPositionFront: Bool = false
    var isFlashOn:Bool
    
    func nothing() {}
    
    
    
    override init() {
        
        closeButton = HAGlobalNode.createBasicButtonNode()
        
        HAGlobalNode.setButton(closeButton, string: "Cancel", textSize: kTextSizeRegular, attributeType: .WhiteTextDarkBackground)

        captureButton = ASButtonNode()
        flashButton = ASButtonNode()
        flipButton = ASButtonNode()
        isFlashOn = false
      
        super.init()
        
        closeButton.backgroundColor   = UIColor.clearColor()
        captureButton.backgroundColor = UIColor.clearColor()
        flashButton.backgroundColor   = UIColor.clearColor()
        flipButton.backgroundColor    = UIColor.clearColor()
        
        captureButton.borderColor = UIColor.whiteColor().CGColor
        
        
        addSubnode(closeButton)
        addSubnode(captureButton)
        addSubnode(flashButton)
        addSubnode(flipButton)
    }
    
    
    override func didLoad() {
        super.didLoad()
        

        
//        captureButton.setBackgroundImage(UIImage(named: "ic_radio_button_checked"), forState: .Normal)
        flashButton.setImage(UIImage(named: "ic_flash_off"), forState: .Normal)
//        captureButton.setImage(UIImage(named: "ic_radio_button_checked"), forState: .Normal)
        flipButton.setImage(UIImage(named: "ic_loop"), forState: .Normal)
        
        disableAllButtons()


        closeButton.addTarget(self, action: #selector(closeCamera), forControlEvents: .TouchUpInside)
        captureButton.addTarget(self, action: #selector(nothing), forControlEvents: .TouchUpInside)
        flashButton.addTarget(self, action: #selector(switchFlashConfig), forControlEvents: .TouchUpInside)
        flipButton.addTarget(self, action: #selector(flipCamera), forControlEvents: .TouchUpInside)
        
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(handleLongPressOnCameraButton))
        longPressGestureRecognizer.minimumPressDuration = 0.5
        captureButton.view.addGestureRecognizer(longPressGestureRecognizer)


        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleTapOnCameraButton))
        tapGestureRecognizer.numberOfTapsRequired = 1
        captureButton.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        setupControls()
    }
    
    
    
//    
//    class func createButtonWithAllStatesSetWithText(text: String) ->ASButtonNode {
//        
//        let button = ASButtonNode()
//        button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
//        button.flexGrow = true
//        
//        let normal = HAGlobal.titlesAttributedString(text, color: UIColor.whiteColor(), textSize: kTextSizeRegular)
//        let highlighted = HAGlobal.titlesAttributedString(text, color: UIColor.darkGrayColor(), textSize: kTextSizeRegular)
//        
//        button.setAttributedTitle(normal, forState: .Normal)
//        button.setAttributedTitle(highlighted, forState: .Highlighted)
//        button.setAttributedTitle(highlighted, forState: .Selected)
//        return button
//    }
//    
    
    
    
    
    /*  ================================================================================
     *  ================================================================================
     *                  Handle User Interactions
     *  ================================================================================
     *  ================================================================================
     */
 
    func handleLongPressOnCameraButton(gestureRecognizer: UIGestureRecognizer) {
        if !videoIsRecording {
            print("Start video recording")
            viewControllerDelegate?.videoStarted()
        }
        print("Continue recording")

        videoIsRecording = true
    }
    
    func handleTapOnCameraButton(gestureRecognizer: UIGestureRecognizer) {
        if videoIsRecording {
            videoIsRecording = false
            viewControllerDelegate?.videoStopped()
            print("Stop recording")
        } else {
            print("Took photo")
            viewControllerDelegate?.photoWillBeTaken()
        }
        
    }
    
    
    func closeCamera() {
        viewControllerDelegate?.dismissCamera()
    }
    

    
    

    
    func setupControls() {
        cameraHasFlash()
        cameraHasFrontCamera()
    }
    
    func cameraHasFrontCamera() {
        if let canFlip = displayDelegate?.cameraHasFlipCamera() {
            if canFlip {
                enableFlipButton(true)
            } else {
                enableFlipButton(false)
            }
        } else {
            enableFlipButton(false)
        }
    }
    
    func cameraHasFlash() {
        if let hasFlash = displayDelegate?.cameraHasFlash() {
            if hasFlash {
                enableFlashButton(true)
            } else {
                enableFlashButton(false)
            }
        } else {
            enableFlashButton(false)
        }
    }
    
    
    func flipCamera() {
        disableAllButtons()
        let didFlip = displayDelegate?.flipCamera()
        
        let cameraPosition = didFlip?.position
        
        if let position = cameraPosition {
            if position == .Front {
                enableFlashButton(false)
            } else {
                enableFlashButton(true)
            }
        }
        enableFlipButton(true)
        enableCaptureButton(true)
    }
    
    func switchFlashConfig() {
        if let flashMode = displayDelegate?.switchFlashConfig() { // return AVCaptureFlashMode

            enableFlashButton(true)

            if flashMode == .On {
                setFlashButtonOn(true)
            } else {
                setFlashButtonOn(false)
            }
        } else {
            enableFlashButton(false)
        }
    }
    
    
    private func setFlashButtonOn(on: Bool) {
        if on {
            flashButton.setImage(UIImage(named: "ic_flash_on"), forState: .Normal)
        } else {
            flashButton.setImage(UIImage(named: "ic_flash_off"), forState: .Normal)
        }
    }
    
    

    
    
    
    
    func disableAllButtons() {
        enableFlashButton(false)
        enableFlipButton(false)
        enableCaptureButton(false)
    }
    
    func enableFlashButton(enabled: Bool) {
        enable(enabled, button: flashButton)
    }
    
    func enableFlipButton(enabled: Bool) {
        enable(enabled, button: flipButton)
    }
    
    func enableCaptureButton(enabled: Bool) {
        enable(enabled, button: captureButton)
    }
    
    private func enable(enabled: Bool, button: ASButtonNode) {
        
        if enabled {
            button.userInteractionEnabled = true
            button.alpha = 1.0
        }
        else {
            button.userInteractionEnabled = false
            button.alpha = 0.3
        }
    }

    
    
    
    
    
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        let closeFlipStack = ASStackLayoutSpec(direction: .Vertical,
                                             spacing: 10,
                                             justifyContent: .SpaceAround ,
                                             alignItems: .Start ,
                                             children: [flipButton, spacer, closeButton])
        
//        closeFlipStack.flexGrow = true
//        closeFlipStack.alignSelf = .Start
//        return closeFlipStack
        
        flashButton.alignSelf = .Start
        
        let cameraWidth = constrainedSize.max.width/5
        
        captureButton.cornerRadius = cameraWidth/2
        captureButton.borderWidth = 10

        
        captureButton.preferredFrameSize = CGSizeMake(cameraWidth, cameraWidth)
        
        let staticCaptureButton = ASStaticLayoutSpec(children: [captureButton])
        
        let controlStack = ASStackLayoutSpec(direction: .Horizontal,
                                                spacing: 0,
                                                justifyContent: .SpaceBetween,
                                                alignItems: .Center,
                                                children: [closeFlipStack, staticCaptureButton, flashButton])
        controlStack.flexGrow = true
        controlStack.alignSelf = .Stretch
        
        let ceilings:CGFloat = 10.0
        let sides:CGFloat = 15.0
    
        let controlStackInset =  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(ceilings, sides, ceilings, sides), child: controlStack)
        
        
        return controlStackInset
        
        //
//        let fullControlStack = ASStackLayoutSpec(direction: .Vertical,
//                                                spacing: 0,
//                                                justifyContent: .SpaceAround,
//                                                alignItems: .Center ,
//                                                children: [controlStack, captureButton])
//        
//
//        
//        
//        let navStack =  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(ceilings, sides, ceilings, sides), child: fullControlStack)
//
//        
//        return navStack
//        
//        
//        
//        
//        
//        
//        let verticalSpacer = ASLayoutSpec()
//        verticalSpacer.flexGrow = true
//        
//        let fullStack = ASStackLayoutSpec(direction: .Vertical,
//                                          spacing: 30,
//                                          justifyContent: .SpaceBetween,
//                                          alignItems: .Center,
//                                          children: [fullControlStack, verticalSpacer, captureButton])
////        fullStack.flexGrow = true
//
//        
//        let a =  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(ceilings, sides, ceilings, sides), child: fullStack)
//        
//        
////        let ab = ASLayout(layoutableObject: a, size: constrainedSize.max)
//       
////        return ab
//        a.flexGrow = true
//        return a

    }
}