//
//  CreateUser.swift
//  PopIn
//
//  Created by Hanny Aly on 5/2/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CreateUserNode: ASDisplayNode, ASEditableTextNodeDelegate {

    let kbackgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
    let kDisabledButtonColor = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 0.6)
    let kEnabledButtonColor = UIColor(white: 1.0, alpha: 1.0)
    
    
    let loadingScreenOverlay  : ASDisplayNode
    let loadingScreenActivityIndicatorView : UIActivityIndicatorView
    
    
    let userPhotoButton: ProfileButtonNode
    let textFieldNode: HATextField
    let nextButton: ASButtonNode
    
    
    
    override init() {
        

        //Center Spining wheel
        loadingScreenActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loadingScreenActivityIndicatorView.color = UIColor.blackColor()

        
        // Full screen Cover to show that screen cannot be used

        loadingScreenOverlay = ASDisplayNode()
        loadingScreenOverlay.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        loadingScreenOverlay.flexGrow = true
        loadingScreenOverlay.layerBacked = true
        
        
        
        
        // Setup username Text Field
        textFieldNode = HATextField(shouldSetLeftPadding: true, useForVerification: true)
        textFieldNode.textField.placeholder = "Select Username"
        textFieldNode.textField.autocapitalizationType = .None
        
        textFieldNode.textField.borderStyle = .RoundedRect

        
        userPhotoButton = ProfileButtonNode()

        
        
        nextButton = ASButtonNode()
        
        nextButton.cornerRadius = 6
        nextButton.borderWidth = 3
        
        
        
        let enabledButtonAttributed = HAGlobal.titlesAttributedString("NEXT",
                                                                      color: kEnabledButtonColor,
                                                                      textSize: kTextSizeSmall)
        let disabledButtonAttributed = HAGlobal.titlesAttributedString("NEXT",
                                                                       color: kDisabledButtonColor,
                                                                       textSize: kTextSizeSmall)

        nextButton.setAttributedTitle(enabledButtonAttributed, forState: .Normal)
        nextButton.setAttributedTitle(disabledButtonAttributed, forState: .Disabled)
        
        super.init()
    }
    

    override func didLoad() {
        super.didLoad()
        
        backgroundColor = kbackgroundColor
        
        enableNextButton(false)
        
        addSubnode(userPhotoButton)
        addSubnode(textFieldNode)
        addSubnode(nextButton)
        addSubnode(loadingScreenOverlay)
        
        blockViewController(false)
        view.addSubview(loadingScreenActivityIndicatorView)
    }
    
    
    override func layout() {
        super.layout()
        loadingScreenActivityIndicatorView.center = view.center
    }
    
    
    func setTextFieldNodeDelegate(vc: RegisterUserVC) {
        textFieldNode.textField.delegate = vc
    }
    
    func photoButtonAddTarget(target: AnyObject?, action: Selector) {
        userPhotoButton.buttonNode.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    func nextButtonAddTarget(target: AnyObject?, action: Selector) {
        nextButton.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    
    
    
    
    func blockViewController(block: Bool) {
        
        if block {
            loadingScreenActivityIndicatorView.startAnimating()
            loadingScreenOverlay.hidden = false
        } else {
            loadingScreenActivityIndicatorView.stopAnimating()
            loadingScreenOverlay.hidden = true
        }
    }
    
    
    //MARK: Next Button Funcs
    
    
    
    func enableNextButton(enabled: Bool) {
        nextButton.enabled = enabled

        if enabled {
            nextButton.borderColor = UIColor.whiteColor().CGColor
        } else {
            nextButton.borderColor = kDisabledButtonColor.CGColor
        }
    }
    
    //MARK: Photo Funcs

    func enableUserPhotoButton( enabled:Bool ) {
        userPhotoButton.enableButton(enabled)
        userPhotoButton.loadingImage(!enabled)
    }

    
    func replaceUserPhoto(image: UIImage) {
        let imageButtonWidth = calculatedSize.width * (3/5)
        print("imageButtonWidth: \(imageButtonWidth)")
        userPhotoButton.setImage(image, cornerRadius: imageButtonWidth)
    }
    
    func userDidSelectProfilePhoto() -> Bool {
        return !userPhotoButton.imageIsNull()
    }
    
    
    
    //MARK: Textfield Funcs
    
    func textField() -> UITextField {
        return textFieldNode.textField
    }
    
    
    func typedUsername() -> String {
        if let username = textFieldNode.textField.text {
            return username
        }
        return ""
    }
    
    

    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let maxWidth = constrainedSize.max.width
        let textFieldHeight: CGFloat = 50.0
        let nextButtonHeight: CGFloat = 40.0
        
        let fourFifthsWidth = maxWidth * (4/5)
        let imageButtonWidth = maxWidth * (3/5)
        
        
//        userPhotoButton.contentEdgeInsets = UIEdgeInsetsMake(128,128,128,128)
        //        userPhotoButton.preferredFrameSize = CGSizeMake(128, 128)
//        
//        userPhotoButton.setBackgroundImage(UIImage(named: "circle"), forState: .Normal)
//        userPhotoButton.backgroundImageNode.contentMode = .ScaleAspectFit
//        userPhotoButton.backgroundImageNode.preferredFrameSize = CGSizeMake(128, 128)
        
        
        
        userPhotoButton.preferredFrameSize = CGSizeMake(imageButtonWidth, imageButtonWidth)
        let staticUserPhotoButtonSpec = ASStaticLayoutSpec(children: [userPhotoButton])


        textFieldNode.preferredFrameSize = CGSizeMake(fourFifthsWidth, textFieldHeight)
        let staticTextNodeSpec = ASStaticLayoutSpec(children: [textFieldNode])

        
        
        nextButton.preferredFrameSize = CGSizeMake(fourFifthsWidth, nextButtonHeight)
        let staticNextButtonSpec = ASStaticLayoutSpec(children: [nextButton])

        
        let textNodesSpec = ASStackLayoutSpec(direction: .Vertical,
                                         spacing: 4,
                                         justifyContent: .SpaceBetween,
                                         alignItems: .Center,
                                         children: [ staticTextNodeSpec])

        
        
        let textSpec = ASStackLayoutSpec(direction: .Vertical,
                                                       spacing: 20,
                                                       justifyContent: .SpaceBetween,
                                                       alignItems: .Center,
                                                       children: [textNodesSpec, staticNextButtonSpec])

        
        
        
        let fullStackSpec = ASStackLayoutSpec(direction: .Vertical,
                                              spacing: 10,
                                              justifyContent: .Start,
                                              alignItems: .Center,
                                              children: [staticUserPhotoButtonSpec, textSpec])
        
        let fullWrapperInsets = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(20, 0, 0, 0) , child: fullStackSpec)

        
        
        
        return ASOverlayLayoutSpec(child: fullWrapperInsets, overlay: loadingScreenOverlay)

    }
    
    
    
    
    
    
    // MARK: helper methods
    
    
    
    
    
    
    
    //MARK: Action Methods

    
    func dismissAllObjects() {
        
        print("dismiss all objects")
    }
}


//extension UIImage {
//  
//    func makeCircularImageWithSize(size: CGSize) -> UIImage {
//        
//        // make a CGRect with the image's size
//        let circleRect = CGRect(origin: CGPointZero, size: size)
//        
//        // begin the image context since we're not in a drawRect:
//        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0)
//        
//        // create a UIBezierPath circle
//        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width/2)
//        
//        // clip to the circle
//        circle.addClip()
//        
//        // draw the image in the circleRect *AFTER* the context is clipped
//        drawInRect(circleRect)
//        
//        // create a border (for white background pictures)
//        #if StrokeRoundedImages
//            circle.lineWidth = 1;
//            UIColor.blackColor().set()
//            circle.stroke()
//        #endif
//        
//        // get an image from the image context
//        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
//        
//        // end the image context since we're not in a drawRect:
//        UIGraphicsEndImageContext()
//        
//        return roundedImage
//    }
//}
//
//extension UIBezierPath {
//    
//    /** Returns an image of the path drawn using a stroke */
//    func strokeMyImageWithColor() -> UIImage {
//        
//        // get your bounds
//        let bounds: CGRect = self.bounds
//        
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(bounds.size.width + self.lineWidth * 2, bounds.size.width + self.lineWidth * 2), false, UIScreen.mainScreen().scale)
//        
//        // get reference to the graphics context
//        let reference: CGContextRef = UIGraphicsGetCurrentContext()!
//        
//        // translate matrix so that path will be centered in bounds
//        CGContextTranslateCTM(reference, self.lineWidth, self.lineWidth)
//        
//        let strokeColor = UIColor.whiteColor()
//
//        let fillColor = UIColor.redColor()
//      
//        
//        // set the color
//        strokeColor.setStroke()
//        fillColor.setFill()
//        
//        
//        // draw the path
//        fill()
//        stroke()
//        
//        
//        // grab an image of the context
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        
//        UIGraphicsEndImageContext()
//        
//        return image
//    }
//    
//}